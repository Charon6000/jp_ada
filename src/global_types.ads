package Global_Types is

   --  Enums
   type Product_Type is (Laptop, Telewizor, Pralka);

   --  Integers
   type Truck_Id is range 1 .. 100;
   type Robot_Id is range 1 .. 100;

   --  Records
   type Delivery is record
      ID : Truck_Id;
      Product : Product_Type;
      Amount : Natural;
      Waiting_Time : Duration;
   end record;

   --  Arrays

   --  Constants
   Max_Hub_Capacity : constant Natural := 100;

private

end Global_Types;