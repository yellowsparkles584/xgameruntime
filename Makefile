# Compiler and Tools
CC = x86_64-w64-mingw32-gcc
WIDL = widl
CFLAGS = -O2 -Wall -I.
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

# Include all IDL files in the repository
IDL_SRCS = $(wildcard *.idl)
IDL_HEADERS = $(IDL_SRCS:.idl=.h)
OBJS = $(C_SRCS:.c=.o)

# Default target
all: $(MODULE)

# 1. Force ALL IDL header files to be generated first
headers: $(IDL_HEADERS)

%.h: %.idl
	$(WIDL) -h -I. -o $@ $<

# 2. Add an explicit dependency: xaccessibility.h requires xspeechsynthesizer.h
xaccessibility.h: xspeechsynthesizer.h

# 3. Ensure C compilation waits for ALL IDL headers to complete
%.o: %.c | headers
	$(CC) $(CFLAGS) -c $< -o $@

# Link the DLL
$(MODULE): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS) $(LIBS)

clean:
	rm -f $(OBJS) $(IDL_HEADERS) $(MODULE)

.PHONY: all headers clean
