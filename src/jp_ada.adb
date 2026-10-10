with Global_Types;
with Hub;
with Unloading;
--  Main procedure of the project
procedure jp_ada is
   zamowienie : Global_Types.Delivery;
begin
   --  Creating a Hub
   Hub.Hub_Task.Get (Global_Types.Laptop, 10);
   --  Creating fictionsal delivery
   zamowienie.ID := 1;
   zamowienie.Product := Global_Types.Laptop;
   zamowienie.Amount := 10;
   zamowienie.Waiting_Time := 10.0;
   --  Giving Delivery to the unloader
   Unloading.Unloading_Task.New_Delivery (New_Delivery => zamowienie);
   --  Closing Hub
   Hub.Hub_Task.Kill;
end jp_ada;
