# Compiler and Tools
CC = x86_64-w64-mingw32-gcc
WIDL = widl
CFLAGS = -O2 -Wall -I. -I/usr/include/wine/windows -I/usr/include/wine
WIDLFLAGS = -h -I. -I/usr/include/wine/windows -I/usr/include/wine
LDFLAGS = -shared -s

# Module and Libraries
MODULE = xgameruntime.dll
LIBS = -lcombase -lbcrypt -lwinhttp -lwininet -lws2_32

# Source Files
C_SRCS = json_min.c main.c shim_ipc.c shim_xml.c sisu_auth.c \
         xaccessibility.c xappcapture.c xdisplay.c xerror.c xgame.c \
         xgameactivation.c xgameevent.c xgameinvite.c xgameprotocol.c \
         xgameruntimefeature.c xgamesave.c xgamestreaming.c xgameui.c \
         xnetworking.c xpackage.c xpersistentlocalstorage.c xstore.c \
         xsystem.c xsystemanalytics.c xthreading.c xuser.c

IDL_SRCS = $(wildcard *.idl)
IDL_HEADERS = $(IDL_SRCS:.idl=.h)
OBJS = $(C_SRCS:.c=.o)

all: $(MODULE)

headers: $(IDL_HEADERS)

%.h: %.idl
	$(WIDL) $(WIDLFLAGS) -o $@ $<

%.o: %.c | headers
	$(CC) $(CFLAGS) -c $< -o $@

$(MODULE): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)

clean:
	rm -f $(OBJS) $(IDL_HEADERS) $(MODULE)

.PHONY: all headers clean
