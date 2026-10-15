with Ada.Numerics.Discrete_Random;
package Global_Types is
   --  Enums
   type Product_Type is (Laptop, Telewizor, Pralka);

   --  Randomizer
      subtype Zakres is Integer range 1 .. 5;
      package Random is
         new Ada.Numerics.Discrete_Random (Zakres);

   --  Integers
   type Truck_Id is range 1 .. 100;
   type Robot_Id is range 1 .. 100;
   type Unloader_Id is range 1 .. 100;

   --  Records
   type Delivery is record
      ID : Truck_Id;
      Product : Product_Type;
      Amount : Natural;
   end record;

   --  Arrays
   
   --  Constants
   Max_Hub_Capacity : constant Natural := 100;
   Max_Truck_Waiting_Time : constant Natural := 20;
   Max_Battery : constant Natural := 100;
   Low_Battery_Threshold : constant Natural := 20;
   Battery_Cost_Per_Stage : constant Natural := 5;
   Max_Charging_Time : Natural := 10;
private

end Global_Types;