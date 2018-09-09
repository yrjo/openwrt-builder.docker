#!/bin/sh

# If GOSU_USER environment variable set to something other than 0:0 (root:root),
# become user:group set within and exec command passed in args
if [ "$GOSU_USER" != "0:0" ]; then
    chown -R $GOSU_USER /src

    # make sure a valid user exists in /etc/passwd
    if grep "^builder:" /etc/passwd; then
      sed -i "/^builder:/d" /etc/passwd
    fi
    echo "builder:x:$GOSU_USER:OpenWRT builder:/src:/bin/bash" >> /etc/passwd
    exec gosu $GOSU_USER "$@"
fi

# If GOSU_USER was 0:0 exec command passed in args without gosu (assume already root)
exec "$@"
