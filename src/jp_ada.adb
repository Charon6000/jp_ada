with Global_Types;
with Hub;
with Unloading;
with Truck;
with Robot;
--  Main procedure of the project
procedure jp_ada is
   --  Creating robots
   Robot1 : Robot.Robot_Task (ID => 1);
   Robot2 : Robot.Robot_Task (ID => 2);
   Robot3 : Robot.Robot_Task (ID => 3);
   --  Creating Unloaders
   Unloader1 : Unloading.Unloading_Task (ID => 1, Hand_Size => 3);
   Unloader2 : Unloading.Unloading_Task (ID => 2, Hand_Size => 4);
   Unloader3 : Unloading.Unloading_Task (ID => 3, Hand_Size => 2);
   --  Creating trucks pointers
   Simple_Truck1 : constant Truck.Truck_Access := new Truck.Truck_Task (
      ID => 1,
      Product => Global_Types.Laptop,
      Amount => 30
   );   
   Simple_Truck2 : constant Truck.Truck_Access := new Truck.Truck_Task (
      ID => 2,
      Product => Global_Types.Pralka,
      Amount => 10
   );
   Simple_Truck3 : constant Truck.Truck_Access := new Truck.Truck_Task (
      ID => 3,
      Product => Global_Types.Telewizor,
      Amount => 13
   );
   --  This one will wait until lose patient and go away
   Simple_Truck4 : constant Truck.Truck_Access := new Truck.Truck_Task (
      ID => 4,
      Product => Global_Types.Laptop,
      Amount => 5
   );
begin
   --  Giving Delivery to the unloader
   Unloader1.New_Delivery (New_Delivery => Simple_Truck1);
   Unloader2.New_Delivery (New_Delivery => Simple_Truck2);
   Unloader3.New_Delivery (New_Delivery => Simple_Truck3);
   --  Closing Objects
   Hub.Hub_Task.Kill;
end jp_ada;
