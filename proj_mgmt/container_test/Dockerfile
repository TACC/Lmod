FROM ubuntu:latest

WORKDIR /app

RUN apt-get update && \
    apt-get install -y tcsh tcl tcl-dev uuid r-base r-base-dev cmake fish tclsh zsh ksh lua5.1 liblua5.1-dev build-essential libreadline-dev unzip wget git && \
    git clone https://github.com/TACC/Hermes.git              && \
    wget https://luarocks.org/releases/luarocks-3.13.0.tar.gz && \
    tar zxpf luarocks-3.13.0.tar.gz                           && \
    cd luarocks-3.13.0                                        && \
    ./configure && make && make install                       && \
    luarocks install luafileSystem                            && \
    luarocks install luajson                                  && \
    luarocks install lua-term                                 && \
    luarocks install busted                                   && \
    luarocks install std.normalize                            && \
    luarocks install luaposix 34.1                            && \
    cd /app                                                   && \
    git clone https://github.com/TACC/Lmod.git
    
        


    
