with Global_Types;
use Global_Types;

package Hub is

   type Magazyn_Stan is record
      Lacznie    : Natural;
      Maks       : Natural;
      Laptopy    : Natural;
      Telewizory : Natural;
      Pralki     : Natural;
      Pelny      : Boolean;
   end record;

   procedure Pobierz_Stan (Stan : out Magazyn_Stan);

   task Hub_Task is
      entry Get (
         Product_gotten : Product_Type;
         Count          : Natural
      );
      entry Check_Capacity (Count : out Integer);
      entry Increase_Max (Count : Natural);
      entry Kill;
   end Hub_Task;

end Hub;