program BintoPascal;

{ Utility for building include files from binary files

MIT license

Last update 23 november 2026 Hans Otten

Requires a file named 'BintoPascal.ini' with specifications for:
- the name of binary file
- the name of the include file to create
- the name of tha datastructure array
- the start adress of the binary in memory
all fields separated by a ',', no leading/trailing blanks

Example for the KIM-1 Simulator

6530-002 fillerbyte00.bin,6530-002.inc,kimrom002,$1C00
6530-003 fillerbyte00.bin,6530-003.inc,kimrom003,$1800
kimsimrom.bin,kimsimrom.inc,kimsimrom,$1500
wozmon.bin,wozmon.inc,wozmon,$1AA0

}


uses  sysutils ;

const
    listfilename = 'BintoPascal.ini' ;

type

  bytefile = file of byte ;



var
  romfile    : bytefile ;
  incfile    : text ;
  listfile   : text ;
  incbinsize : integer ;
  command    : string ;
  romfilename : string ;
  incfilename : string ;
  inctext     : string ;
  loadaddress : string  ;
  comma : integer ;

procedure writeincfile(var romfile : bytefile ;
                       var incfile : text ;
                       binsize : integer) ;

var
  cnt          : integer ;
  value        : byte ;

begin

  writeln(incfile,'  (') ;
  write(incfile,'  ') ;
  cnt := 0 ;
  while cnt < binsize  do
    begin
      read(romfile, value) ;
      write(incfile,'$', inttohex(value,2));
      if cnt < (binsize - 1)
        then
          write(incfile, ', ') ;
      if ((cnt + 1) mod 16) = 0
        then
          begin
            writeln(incfile) ;
            write(incfile,'  ') ;
          end ;
      inc(cnt) ;
    end;

  writeln(incfile,') ;') ;
  writeln(incfile) ;

end ;


function GetFiledate(filename : string) : string ;
var
  S : TDateTime;
  fa : Longint;
begin
  fa:=FileAge(filename);
  If Fa<>-1 then
    begin
    S:=FileDateTodateTime(fa);
    GetFileDate := DateTimeToStr(S) ;
    end;
end ;

procedure doincfile(romfilename : string ;
                       incfilename : string ;
                       inctext     : string ;
                       loadaddress : integer ) ;

begin

  { open bin file }
  if not FileExists(romfilename)
    then
      begin
        writeln('File not found ', romfilename) ;
        exit
      end;
  assign(romfile, romfilename) ;
  reset(romfile) ;
  incbinsize := FileSize(romfile) ;

  { open include file }
  assign(incfile, incfilename) ;
  rewrite(incfile) ;

  { header }

  writeln(incfile,'{ Binary include of ', romfilename,' }' ) ;
  writeln(incfile,'{ Date of BIN file  ', GetFiledate(romfilename),' }' ) ;
  writeln(incfile) ;
  writeln(incfile, inctext,'size = ', incbinsize,' ;') ;
  writeln(incfile, inctext,'load = $', inttohex(loadaddress,4), ' ;') ;
  writeln(incfile, inctext,': array[0..', (incbinsize - 1),'] of byte =') ;
  writeln(incfile) ;

  writeincfile(romfile, incfile, incbinsize) ;


  { close files }
  closefile(romfile) ;
  closefile(incfile) ;

  writeln(inctext,' include file created') ;

end ;


procedure Splitcommand(command : string ;
                       var romfilename,
                           incfilename,
                           inctext,
                           loadaddress : string ) ;

{ four strings separated by a comma }
var
  comma  : integer ;
  cnt    : integer ;
  oldpos : integer ;
begin

  romfilename := '' ;
  incfilename := '' ;
  inctext     := '' ;
  loadaddress := '' ;
  oldpos := 1 ;
  comma := pos(',',command, oldpos) ;
  for cnt := oldpos to (comma-1) do
    begin
      romfilename := romfilename + command[cnt] ;
      oldpos := oldpos + 1
    end ;
  comma := pos(',',command, comma + 1) ;
  for cnt := oldpos + 1  to (comma - 1) do
    begin
      incfilename := incfilename + command[cnt] ;
      oldpos := oldpos + 1
    end ;
  comma := pos(',',command, comma +1) ;
  for cnt := oldpos + 2   to (comma - 1) do
    begin
      inctext := inctext + command[cnt] ;
      oldpos := oldpos + 1
    end ;
  for cnt := (oldpos + 3) to length(command) do
    loadaddress := loadaddress + command[cnt] ;

end ;

begin

  writeln('Creating ROM include files V1.1 Hans Otten 2026') ;
  if not FileExists(listfilename)
    then
      begin
        writeln('File not found ', listfilename) ;
        exit
      end;
  { open list of files to create inc files of }
  assign(listfile, listfilename) ;
  reset(listfile) ;
  while not eof(listfile) do
    begin
      readln(listfile, command) ;

      splitcommand(command,
                   romfilename,
                   incfilename,
                   inctext,
                   loadaddress)  ;


      doincfile(romfilename,
                incfilename,
                inctext,
                strtoint(loadaddress))  ;

                end;
  { close listfile }
  closefile(listfile) ;
end.

