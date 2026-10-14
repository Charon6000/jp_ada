with Ada.Characters.Latin_1;
with Hub;
with Logger;

package body Monitor is

   function Trim_Image (N : Natural) return String is
      Img : constant String := Natural'Image (N);
   begin
      if Img (Img'First) = ' ' then
         return Img (Img'First + 1 .. Img'Last);
      else
         return Img;
      end if;
   end Trim_Image;

   task body Monitor_Task is
      use Ada.Characters.Latin_1;
      NL   : constant String := (1 => LF);
      Stan : Hub.Magazyn_Stan;
      Raport : String (1 .. 512);
      Len : Natural := 0;

      procedure Append (S : String) is
         L : constant Natural := S'Length;
      begin
         if Len + L <= Raport'Length then
            Raport (Len + 1 .. Len + L) := S;
            Len := Len + L;
         end if;
      end Append;

   begin
      loop
         delay 6.0;

         Hub.Pobierz_Stan (Stan);

         Len := 0;
         Append ("Magazyn ogolem: ");
         Append (Trim_Image (Stan.Lacznie));
         Append ("/");
         Append (Trim_Image (Stan.Maks));
         Append (" szt.");
         Append (NL);
         Append ("- Laptopy: ");
         Append (Trim_Image (Stan.Laptopy));
         Append (" szt.");
         Append (NL);
         Append ("- Telewizory: ");
         Append (Trim_Image (Stan.Telewizory));
         Append (" szt.");
         Append (NL);
         Append ("- Pralki: ");
         Append (Trim_Image (Stan.Pralki));
         Append (" szt.");
         Append (NL);
         Append ("==================================");

         Logger.Log_Raport (
            Header  => "=== STAN CENTRUM LOGISTYCZNEGO ===",
            Message => Raport (1 .. Len));

         exit when Stan.Pelny;
      end loop;
   end Monitor_Task;

end Monitor;