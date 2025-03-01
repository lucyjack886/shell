#!/bin/bash

# 创建目录（如果不存在）
mkdir -p /root/cert

# 写入 server.key
cat > /root/cert/server.key <<EOF
-----BEGIN PRIVATE KEY-----
MIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDHkoD9FHi3GRFZ
ENVJuQuLpmIbn4EhzsndsalLO3BleJUFA1k0Eq7yAw5iO9js4RVtdnrXBCHV6Eyv
ZzY7DHXRv5syO3jOpU7JMZTbfDm9JG18gbBUgfhtDOlfL+2VdAvseLxqkxXC5Lrc
nlfPtmesJD11RK3sgNwPJ7q9dORPgGEx3a01CcZxy2IqtZlx8pNBIcBv8V5DwQS3
CS3zwVof6BCNNtiN4H+4lDcnDl5VFJKGJn5t7amD7vdMii6Nd5X/75vCCizNtirB
VItLZFET9kF3ftI4TeWmf5ns2Vq4teRth/Phe9h7dOVweA9qwHM57an5gLj6S2LH
Z9ft/g47AgMBAAECggEAWkV+avtzjv6bxjnDAFHfUw+zmOMROgWbcdgGx6zfLkbY
wSe+lbtNvtJ7ExwXBy7YzmalMdUAqQ0mgsCg2xzLvlB5FsOn5XEIriDrQEx0oYV0
sLjI1bDkeg85EIFRaiTPr+r87wgQ89MaYuiMt7u+MTNDSWQDd9Lht0k1QrU5AGw5
CHCEcaRwZRrGsPvYEo/oIm1kyo4ZTH8YkcbaTzsbOHfeHLCbHyvE/NJUCL3uZU0+
5YN/cA7VehxE69LXTfJj/fKYu5h2bUlCd4kDcmbvJ8keNz0pCf17qFiBuJDyIk6n
oTYfHxmxzIImDXBuSx03HM1OKeUVQGHzQ0aUP6p7gQKBgQDlpGv705bXzozYB+MA
WXyiI2L6kr+fXr3jKT/oWs3fa73KSaar80R6JsBtchWiy9KsnluceDUYZ1tNrg7y
/aHqDCL++8wr7u/cG4nnG9K6qrVAilpJT/+sFFLxEPBrILdn9e4bmjs/xvRuvG5Y
sfmiwWhUju8NQkXPrwj3x05UCwKBgQDeeokbB6D+ymOSXAEeYI16IQxUSUorRNTw
AuSPbtSlQ8Tv1Pd+pWWC2lboHO4IFzLeuy0vPKc2fx0Vfy/vmC3yjknyWoaqOHx0
tRlFRBnzaaGsQfx/LHAHS3aHnoDnIxfKJ/axt679LCAijzpaW2kUS9pRqHFGziu/
eQG3cJXckQKBgQDkzSKt4M5tLKXV5F2/DmoIXfuTLz1vO4U0XPgIuNhgX8fUUfeX
YST8E7osEbwO3MeGJ62dQ4ObUfd9eQv5/M0jFX6U0SpHJ6SiiGmo82bNh6JZsL9u
Rh+2QvW0rCzuf8Vc9oKLy+p2i/MklefXxVO1XsBlZ5g0fLBz0bC8tz6KqwKBgQCJ
nU4VlCB3ugThUVu3yI16j9qqgDMKlKcKVx+9wRZzq3mzyA3XHsOtrxS2ur5Z7s+e
ijUm1OOxh+sbkvK5x24UbQM8j9ZgkFQbdLHO8JMEx8AjZyWiHICnYnxM4zRkxIZA
m3uy7iWloJe4CNRVc9mJnmnKvOBkpb7VzynKqC9qoQKBgQCRaxKUQXsHTtmKYgql
M9zEGe0K8kfHFUdjupG2b9Wu1f2O4JPTUTod12gV011JULecU72J4PWpn6gjb22y
nI8/dL2fzeXpF9+GXAh6XWP3Ss91Xb4eFCEeai7npwmB6LXvYgkEuoTkD7vaB7dS
5PMvSUn1C+TwBgPZ640vzDddxA==
-----END PRIVATE KEY-----
EOF

# 写入 server.crt
cat > /root/cert/server.crt <<EOF
-----BEGIN CERTIFICATE-----
MIIDqzCCApOgAwIBAgIUK9QZuRqo4Y7GJHuVVESxPIcyfyQwDQYJKoZIhvcNAQEL
BQAwZTELMAkGA1UEBhMCQVUxCzAJBgNVBAgMAmFiMQ0wCwYDVQQHDARjaXR5MQow
CAYDVQQKDAFhMQowCAYDVQQLDAFhMQowCAYDVQQDDAFhMRYwFAYJKoZIhvcNAQkB
FgdhQGEuY29tMB4XDTI1MDExNjEzNDc1OVoXDTM1MDExNDEzNDc1OVowZTELMAkG
A1UEBhMCQVUxCzAJBgNVBAgMAmFiMQ0wCwYDVQQHDARjaXR5MQowCAYDVQQKDAFh
MQowCAYDVQQLDAFhMQowCAYDVQQDDAFhMRYwFAYJKoZIhvcNAQkBFgdhQGEuY29t
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAx5KA/RR4txkRWRDVSbkL
i6ZiG5+BIc7J3bGpSztwZXiVBQNZNBKu8gMOYjvY7OEVbXZ61wQh1ehMr2c2Owx1
0b+bMjt4zqVOyTGU23w5vSRtfIGwVIH4bQzpXy/tlXQL7Hi8apMVwuS63J5Xz7Zn
rCQ9dUSt7IDcDye6vXTkT4BhMd2tNQnGcctiKrWZcfKTQSHAb/FeQ8EEtwkt88Fa
H+gQjTbYjeB/uJQ3Jw5eVRSShiZ+be2pg+73TIoujXeV/++bwgoszbYqwVSLS2RR
E/ZBd37SOE3lpn+Z7NlauLXkbYfz4XvYe3TlcHgPasBzOe2p+YC4+ktix2fX7f4O
OwIDAQABo1MwUTAdBgNVHQ4EFgQUM1TQtBC9M3zjkGjlJojEUTgNd5wwHwYDVR0j
BBgwFoAUM1TQtBC9M3zjkGjlJojEUTgNd5wwDwYDVR0TAQH/BAUwAwEB/zANBgkq
hkiG9w0BAQsFAAOCAQEALR18sCZOc94oiSO2b3Ho4zE0f7yfpF3IYSDT4/P6Qf/r
fP4Goy4/Php21rYOLqqh6V8yA+qmR4szWHAvBs6yjYMhY6pHvso+lJCT3f39Pzm5
-----END CERTIFICATE-----
EOF

# 设置权限
chmod 600 /root/cert/server.key /root/cert/server.crt
