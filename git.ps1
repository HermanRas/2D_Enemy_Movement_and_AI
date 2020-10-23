$comment = Read-Host -Prompt 'Input commit comment'
git add "C:\inetpub\wwwroot\Godot\DEV\2D_Enemy_Movement_and_AI"
git commit -m "project updated"
git fetch
git pull origin main