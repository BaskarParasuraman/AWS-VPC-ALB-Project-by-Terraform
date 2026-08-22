#!/bin/bash

apt update
apt install -y apache2 curl awscli

# Get the instance ID using IMDSv2
TOKEN=$(curl -s -X PUT \
  -H "X-aws-ec2-metadata-token-ttl-seconds: 21600" \
  http://169.254.169.254/latest/api/token)

INSTANCE_ID=$(curl -s \
  -H "X-aws-ec2-metadata-token: $TOKEN" \
  http://169.254.169.254/latest/meta-data/instance-id)

cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
  <title>My Portfolio</title>
  <style>
    @keyframes colorChange {
      0% { color: red; }
      50% { color: green; }
      100% { color: blue; }
    }

    h1 {
      animation: colorChange 2s infinite;
    }
  </style>
</head>
<body>

  <h1>AWS Server 2 created by Terraform</h1>

  <h2>
    Instance ID:
    <span style="color:green">$INSTANCE_ID</span>
  </h2>

  <h3>This is from Second Instance</h3>

</body>
</html>
EOF

# Start Apache and enable it on boot
systemctl start apache2
systemctl enable apache2