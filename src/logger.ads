package Logger is
   procedure Log (Module : Integer; Sender : String; Message : String);
   procedure Log_S (Module : String; Sender : String; Message : String);
   procedure Log_Raport (Message : String);
private
end Logger;