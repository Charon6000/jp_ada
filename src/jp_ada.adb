with Global_Types;
with Unloading;
with Truck;
with Robot;
with Hub;
with Monitor;
--  Main procedure of the project
procedure jp_ada is
   --  Creating robots
   Robot1 : constant Robot.Robot_Access :=
   new Robot.Robot_Task (ID => 1, Hand_Size => 3);
   Robot2 : constant Robot.Robot_Access :=
   new Robot.Robot_Task (ID => 2, Hand_Size => 1);
   Robot3 : constant Robot.Robot_Access :=
   new Robot.Robot_Task (ID => 3, Hand_Size => 2);
   --  Creating Unloaders
   Unloader1 : constant Unloading.Unloading_Access :=
   new Unloading.Unloading_Task (ID => 1, Hand_Size => 3);
   Unloader2 : constant Unloading.Unloading_Access :=
   new Unloading.Unloading_Task (ID => 2, Hand_Size => 1);
   Unloader3 : constant Unloading.Unloading_Access :=
   new Unloading.Unloading_Task (ID => 3, Hand_Size => 2);
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
   --  Assigning Robots to the Unloaders
   Robot1.Transport (Product => Global_Types.Laptop, Unloader => Unloader1);
   Robot2.Transport (Product => Global_Types.Pralka, Unloader => Unloader2);
   Robot3.Transport (Product => Global_Types.Telewizor, Unloader => Unloader3);
   --  Assigning workers to monitor
   Monitor.Reporter.AddTruck (1, Simple_Truck1);
   Monitor.Reporter.AddTruck (2, Simple_Truck2);
   Monitor.Reporter.AddTruck (3, Simple_Truck3);
   Monitor.Reporter.AddTruck (4, Simple_Truck4);
   Monitor.Reporter.AddUnloader (1, Unloader1);
   Monitor.Reporter.AddUnloader (2, Unloader2);
   Monitor.Reporter.AddUnloader (3, Unloader3);
   --  Robots are assigning themself
end jp_ada;
