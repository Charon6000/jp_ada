with Ada.Text_IO;

package body Logger is
   --  Making an object for logs not to mix
   protected Printer is
      procedure Print (Text : String);
   end Printer;
   protected body Printer is
      procedure Print (Text : String) is
      begin
         Ada.Text_IO.Put_Line (Text);
      end Print;
   end Printer;
   procedure Log (Module : Integer; Sender : String; Message : String) is
   begin
         Printer.Print ("[" & Integer'Image (Module) &
         ":" & Sender & "] " & Message);
   end Log;
   procedure Log_Raport (Header : String; Message : String) is
   begin
         Printer.Print (Header);
         Printer.Print (Message);
   end Log_Raport;
end Logger;