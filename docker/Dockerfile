# syntax=docker/dockerfile:1
FROM alpine:3.14.3
# set up sshd to run in background
VOLUME /sys/fs/cgroup
RUN mkdir -p /run/openrc && \
 touch /run/openrc/softlevel && \
 apk add make git abuild openssh openrc sudo \
 python3 xauth xeyes python3-tkinter gdb strace \
 shadow bash
ENV CONFIG=/etc/ssh/sshd_config
ARG IUSER  # passed in with `--build-arg INAME=$(INAME)` in Makefile
ARG PROJECTDIR  # ditto
RUN mv $CONFIG $CONFIG.orig && \
 sed -e 's/.*Port 22$/Port 3022/' \
  -e 's/^X11Forwarding no$/X11Forwarding yes/' \
 $CONFIG.orig > $CONFIG
# running sshd in foreground, but running these now to create host keys
RUN rc-update add sshd && rc-status && rc-service sshd restart || true
# allow ssh login
# (can't use long options, this is busybox adduser)
RUN echo creating user-level account for $IUSER
#RUN adduser --disabled-password --shell /bin/ash --gecos "" $IUSER && \
RUN adduser -D -s /bin/ash -g "" $IUSER && \
 echo "$IUSER ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/$IUSER && \
 chmod 0440 /etc/sudoers.d/$IUSER
# unlock the account or you cannot login: unix.stackexchange.com/a/193131/2769
RUN usermod -p '*' $IUSER
#RUN echo $IUSER:'*' | chpasswd -e  # -e means "already encrypted"
RUN mkdir -m 700 -p /home/$IUSER/.ssh
RUN echo cd $PROJECTDIR >> /home/$IUSER/.profile
RUN chown -R $IUSER:$IUSER /home/$IUSER
# allow $IUSER to run abuild -r
RUN usermod -a -G abuild $IUSER
# command to run
CMD ["/bin/bash"]
EXPOSE 3022
