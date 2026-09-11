# Compiler and Tools
CC = x86_64-w64-mingw32-gcc
WIDL = widl
CFLAGS = -O2 -Wall -I.
LDFLAGS = -shared -s

# Module and Libraries from your template
MODULE = xgameruntime.dll
LIBS = -lcombase -lbcrypt -lwinhttp -lwininet -lws2_32

# Source Files
C_SRCS = json_min.c main.c shim_ipc.c shim_xml.c sisu_auth.c \
         xaccessibility.c xappcapture.c xdisplay.c xerror.c xgame.c \
         xgameactivation.c xgameevent.c xgameinvite.c xgameprotocol.c \
         xgameruntimefeature.c xgamesave.c xgamestreaming.c xgameui.c \
         xnetworking.c xpackage.c xpersistentlocalstorage.c xstore.c \
         xsystem.c xsystemanalytics.c xthreading.c xuser.c

IDL_SRCS = xaccessibility.idl xappcapture.idl xasyncprovider.idl xdisplay.idl \
           xerror.idl xgame.idl xgameactivation.idl xgameevent.idl \
           xgameinvite.idl xgameprotocol.idl xgameruntimefeature.idl \
           xgamesave.idl xgamestreaming.idl xgameui.idl xnetworking.idl \
           xpackage.idl xpersistentlocalstorage.idl xstore.idl xsystem.idl xuser.idl

IDL_HEADERS = $(IDL_SRCS:.idl=.h)
OBJS = $(C_SRCS:.c=.o)

# Default target
all: $(MODULE)

# Generate header files from .idl files using widl
%.h: %.idl
	$(WIDL) -h -o $@ $<

# Compile C source files into object files (depends on generated headers)
%.o: %.c $(IDL_HEADERS)
	$(CC) $(CFLAGS) -c $< -o $@

# Link everything into the final DLL
$(MODULE): $(IDL_HEADERS) $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)

clean:
	rm -f $(OBJS) $(IDL_HEADERS) $(MODULE)

.PHONY: all clean
