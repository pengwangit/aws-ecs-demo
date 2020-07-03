[
   {
     "name": "nginx",
     "image": "${latest_nginx_image_url}",
     "memoryReservation": 128,
     "memory": 256,
     "cpu": 256,
     "essential": true,
     "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${nginx_service}",
            "awslogs-region": "${region}",
            "awslogs-stream-prefix": "${nginx_service}"
        }
     },
     "portMappings": [
       {
         "containerPort": 80,
         "protocol": "tcp"
       }
     ],
     "links": [
       "app"
     ]
   },
   {
     "name": "app",
     "image": "${latest_app_image_url}",
     "memoryReservation": 128,
     "memory": 256,
     "cpu": 256,
     "essential": true,
     "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${app_service}",
            "awslogs-region": "${region}",
            "awslogs-stream-prefix": "${app_service}"
        }
     },
     "environment": [
        {
          "name": "DB_HOST",
          "value": "${db_host}"
        }
     ],
     "secrets": [
        {
          "valueFrom": "${db_secret_arn}:dbname::",
          "name": "DB_NAME"
        },
        {
          "valueFrom": "${db_secret_arn}:username::",
          "name": "DB_USER"
        },
        {
          "valueFrom": "${db_secret_arn}:password::",
          "name": "DB_PASSWORD"
        }
     ]
   }
]