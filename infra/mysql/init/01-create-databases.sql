CREATE DATABASE IF NOT EXISTS sellclip_auth;
CREATE DATABASE IF NOT EXISTS sellclip_clip;
CREATE DATABASE IF NOT EXISTS sellclip_ai;

GRANT ALL PRIVILEGES ON sellclip_auth.* TO 'sellclip'@'%';
GRANT ALL PRIVILEGES ON sellclip_clip.* TO 'sellclip'@'%';
GRANT ALL PRIVILEGES ON sellclip_ai.* TO 'sellclip'@'%';
FLUSH PRIVILEGES;

