
# from channels.generic.websocket import AsyncWebsocketConsumer
# import json
# import asyncio


# class TaskStatusConsumer(AsyncWebsocketConsumer):
    
#     async def connect(self):
#         print("is connecting")
#         self.task_id = self.scope['url_route']['kwargs']['task_id']
#         self.group_name = f'task_{self.task_id}'

#         # Join task group
#         await self.channel_layer.group_add(self.group_name, self.channel_name)
#         await self.accept()

#     async def disconnect(self, close_code):
#         # Leave task group
#         await self.channel_layer.group_discard(self.group_name, self.channel_name)

#     async def send_task_status(self, event):
#         print(f"TaskStatusConsumer: Sending status {event['status']}")
#         status = event['status']

#         await self.send(text_data=json.dumps({
#             'status': status,
#         }))


import json
from channels.generic.websocket import AsyncWebsocketConsumer
from redis import Redis
from channels.db import database_sync_to_async  # Import sync_to_async

# Initialize Redis client
redis_client = Redis(host='localhost', port=6379, db=0)

class TaskStatusConsumer(AsyncWebsocketConsumer):
    
    async def connect(self):
        print("is connecting")
        self.task_id = self.scope['url_route']['kwargs']['task_id']
        self.group_name = f'task_{self.task_id}'

        # Join task group
        await self.channel_layer.group_add(self.group_name, self.channel_name)
        await self.accept()

        # Fetch current progress from Redis
        current_progress = await self.get_task_progress(self.task_id)
        await self.send_initial_progress(current_progress)

    async def disconnect(self, close_code):
        # Leave task group
        await self.channel_layer.group_discard(self.group_name, self.channel_name)

    async def send_task_status(self, event):
        print(f"TaskStatusConsumer: Sending status {event['status']}")
        status = event['status']

        # Update Redis with the new status
        await self.update_task_progress(self.task_id, status)

        # Send the updated task status to the WebSocket client
        await self.send(text_data=json.dumps({
            'status': status,
        }))

    async def send_initial_progress(self, current_progress):
        """Send the current task progress immediately upon connection."""
        print("initial progress -->", current_progress)
        await self.send(text_data=json.dumps({
            'status': current_progress,
        }))

    @database_sync_to_async  # Use this decorator for the sync functions
    def get_task_progress(self, task_id):
        """Fetch the current task progress from Redis."""
        progress = redis_client.get(f'task_progress_{task_id}')
        return float(progress) if progress else 0.0  # Return 0.0 if not found

    @database_sync_to_async
    def update_task_progress(self, task_id, status):
        """Update the task progress in Redis."""
        redis_client.set(f'task_progress_{task_id}', status)
