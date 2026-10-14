with Logger;

package body Hub is

   protected Magazyn is
      procedure Dodaj (Produkt : Product_Type; Ilosc : Natural);
      procedure Ustaw_Max_Z_Rozladunku (Ilosc : Natural);
      procedure Pobierz (Stan : out Magazyn_Stan);
      procedure Oznacz_Pelny;
   private
      Capacity         : Natural := 0;
      Max_In_Unloaders : Natural := 0;
      C_Laptop         : Natural := 0;
      C_Telewizor      : Natural := 0;
      C_Pralka         : Natural := 0;
      Is_Full          : Boolean := False;
   end Magazyn;

   protected body Magazyn is
      procedure Dodaj (Produkt : Product_Type; Ilosc : Natural) is
      begin
         Capacity := Capacity + Ilosc;
         case Produkt is
            when Laptop    => C_Laptop := C_Laptop + Ilosc;
            when Telewizor => C_Telewizor := C_Telewizor + Ilosc;
            when Pralka    => C_Pralka := C_Pralka + Ilosc;
         end case;
      end Dodaj;

      procedure Ustaw_Max_Z_Rozladunku (Ilosc : Natural) is
      begin
         Max_In_Unloaders := Max_In_Unloaders + Ilosc;
      end Ustaw_Max_Z_Rozladunku;

      procedure Pobierz (Stan : out Magazyn_Stan) is
         Effective_Max : Natural :=
            Natural'Min (Max_Hub_Capacity, Max_In_Unloaders);
      begin
         Stan.Lacznie    := Capacity;
         Stan.Maks       := Effective_Max;
         Stan.Laptopy    := C_Laptop;
         Stan.Telewizory := C_Telewizor;
         Stan.Pralki     := C_Pralka;
         Stan.Pelny      :=
            Is_Full
            or (Effective_Max > 0 and Capacity >= Effective_Max)
            or Capacity >= Max_Hub_Capacity;
      end Pobierz;

      procedure Oznacz_Pelny is
      begin
         Is_Full := True;
      end Oznacz_Pelny;
   end Magazyn;

   procedure Pobierz_Stan (Stan : out Magazyn_Stan) is
   begin
      Magazyn.Pobierz (Stan);
   end Pobierz_Stan;

   task body Hub_Task is
      Finish   : Boolean := False;
      Capacity : Natural := 0;
   begin
      while not Finish loop
         select
            when Capacity < Max_Hub_Capacity =>
               accept Get (
                  Product_gotten : Product_Type;
                  Count          : Natural
               ) do
                  Logger.Log (
                     3, "Hub",
                     "Got delivery of "
                     & Integer'Image (Count)
                     & " x "
                     & Product_Type'Image (Product_gotten)
                     & " products");
                  Magazyn.Dodaj (Product_gotten, Count);
                  Capacity := Capacity + Count;
                  declare
                     S : Magazyn_Stan;
                  begin
                     Magazyn.Pobierz (S);
                     if S.Pelny then
                        Magazyn.Oznacz_Pelny;
                        Finish := True;
                     end if;
                  end;
               end Get;
         or
            accept Check_Capacity (Count : out Integer) do
               Count := Integer (Capacity);
            end Check_Capacity;
         or
            accept Increase_Max (Count : Natural) do
               Magazyn.Ustaw_Max_Z_Rozladunku (Count);
            end Increase_Max;
         or
            accept Kill do
               Finish := True;
            end Kill;
         or
            delay 2.0;
            Logger.Log (
               3, "Hub",
               "I have "
               & Natural'Image (Capacity)
               & " products");
         end select;
      end loop;
      Logger.Log (3, "Hub", "I am full");
   end Hub_Task;

end Hub;