with Global_Types;
with Logger;
with Hub;

--  Main procedure of the project
procedure jp_ada is
begin
   Logger.Log (1, "Admin", "Hello from logger!");
   Logger.Log_Raport ("!!!  Raport   !!!", "Hello from logger_raport!");

   Hub.Hub_Task.Get (Global_Types.Laptop, 10);
   Hub.Hub_Task.Kill;
end jp_ada;
