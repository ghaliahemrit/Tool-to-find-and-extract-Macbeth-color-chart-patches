
@echo off
for %%f in (*.CR2 *.TIF) do ( dcraw9.27 -v -r 1 1 1 1 -g 1 1 -o 0 -4 -D -M -W -T %%f )









