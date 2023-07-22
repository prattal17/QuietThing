exe		= bequiet
LDLIBS	= -lpigpio -lrt
INC		= -I/inc

SRC := $(wildcard /src/*.cpp)

all: clean $(exe)

$(exe):
	g++ $(SRC) $(INC) $(LDLIBS) -o $(exe)

clean:
	rm -f $(exe)