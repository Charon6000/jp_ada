with Ada.Text_IO;

package body Logger is

   --  Making an object for logs not to mix
   protected Printer is
      procedure Print(Text: in String);
   end Printer;

   protected body Printer is
      procedure Print(Text: in String) is
      begin
         Ada.Text_IO.Put_Line(Text);
      end Print;
   end Printer;

   procedure Log(Module: in Integer; Sender: in String; Message: in String) is
   begin
         Printer.Print ("[" & Integer'Image(Module) & ":" & Sender & "] " & Message);
   end Log;

   procedure Log_Raport(Header: in String; Message: in String) is
   begin
         Printer.Print (Header);
         Printer.Print (Message);
   end Log_Raport;
end Logger;