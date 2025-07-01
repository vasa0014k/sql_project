create database SQL_project ;
use sql_project;
show databases;

-- sheet 1

create table grades select `Customer ID`,
case
when (ApplicantIncome > 15000) then "Grade A"
when (ApplicantIncome > 9000)  then "Grade B"
when (ApplicantIncome > 5000) then "Middle Class Customer"
else "Low Class Customer"
end "Customer Grades",
case 
when (ApplicantIncome <5000 and Property_Area = "Urban") then 5
when (ApplicantIncome <5000 and Property_Area = "Semiurban") then 3.5
when (ApplicantIncome <5000 and Property_Area = "rural") then 3
when (ApplicantIncome <5000 and Property_Area = "semiurban") then 2.5
else 7
end "Montly_Interst_Percentage"
from customer_income ;
-- sheet 2

create table Loan_detail (Loan_Id  varchar(50) ,Customer_Id varchar (50) ,
 Loan_amount varchar(50) , Loan_amount_term int , Cibil_Score varchar(50) );
 
 
 delimiter $$
 create trigger null_check before insert on loan_detail for each row 
 begin
 if new .Loan_amount is null then set new .Loan_amount = "Loan Still Processing";
 end if;
 end $$ 
 delimiter ;
 show triggers;
 
 insert into Loan_detail select * from loan_status;
 
 select * from loan_detail;
 
  -- table 1
 create table Loan_cibil_detail_remaks(Loan_Id  varchar(50) ,Customer_Id varchar (50) ,
 Loan_amount varchar(50) , Loan_amount_term int , Cibil_Score varchar(50),primary key(customer_id));
 show triggers;
 drop table loan_cibil_detail_remaks;

 -- table 2
 create table Loan_cibil_detail_remaks1(customer_id varchar(50), cibil_score int ,cibil_score_remark varchar(50),primary key(customer_id));
 
   delimiter $$
  create trigger cibil_check_remark after insert on loan_cibil_detail_remaks for each row
  begin
  
  if new. Cibil_Score >900 then insert into loan_cibil_detail_remaks1 (customer_id ,cibil_score,cibil_score_remark) values
  (new.customer_id ,new .cibil_score ,"High cibil score");

  
  elseif new. Cibil_Score >750 then insert into loan_cibil_detail_remaks1 (customer_id ,cibil_score,cibil_score_remark) values
  (new .customer_id ,new .cibil_score ,"No penalty");
  
  
  elseif new. Cibil_Score >0 then insert into loan_cibil_detail_remaks1 (customer_id ,cibil_score,cibil_score_remark) values
  (new. customer_id ,new .cibil_score ,"penalty Customer");

  
  elseif new. Cibil_Score <=0 then insert into loan_cibil_detail_remaks1 (customer_id ,cibil_score,cibil_score_remark) values
  (new .customer_id ,new .cibil_score ,"Reject Customer");
  end if;
  
  end $$
  delimiter ;
  
  insert into Loan_cibil_detail_remaks select * from loan_detail;
  SELECT * FROM loan_cibil_detail_remaks1;
  
create table table_x select r.*,r1.cibil_score_remark 
from loan_cibil_detail_remaks1 as r1 inner join loan_cibil_detail_remaks as r on r1.customer_id = r.Customer_Id;
  
delete from table_x where Loan_amount = "loan still processing"; 
select * from table_x;
DESC table_x;
alter table table_x modify Loan_amount int;
 
 create table table_x1 select x.* , g.`Customer Grades`,g.Montly_Interst_Percentage from table_x as x inner join grades as g on x.Customer_Id = g.`Customer ID`;
 
 create table table_x2 select Customer_Id,round(Loan_amount * Montly_Interst_Percentage) as monthly ,
 round((Loan_amount * Montly_Interst_Percentage) * 12)as Annual 
 from table_x1;
  
   create table loan_cibil_score select i.*,x1.Loan_amount,x1.Cibil_Score,
  x1.cibil_score_remark,x1.`Customer Grades`,x1.Montly_Interst_Percentage,x2.Annual,x2.monthly 
  from customer_info as i inner join table_x1 as x1 on i.`Customer ID` = x1.Customer_Id inner join table_x2 as x2 on x1.Customer_Id = x2.Customer_Id;
  
  SELECT * FROM loan_cibil_score;
  
select s.* ,c.Region_id,c.Postal_Code,c.Segment,c.State,r.Region from loan_cibil_score as s inner join country_state as c on s.`Customer ID` = c.Customer_id 
inner join region_info as r on s.Region_id = r.Region_Id ;

select * from  output_1 ;
desc  output_1;

update output_1 set gender = "female" where `Customer ID` in ('IP43006','IP43016','IP43508','IP43577','IP43589','IP43593');
update output_1 set gender = "male" where `Customer ID` in( 'IP43018','IP43038');
update output_1 set age = 32 where `Customer ID` = "IP43009";

select * from  output_1 ; -- output 1
select o.*,r.* from output_1 as o right join region_info as r on o.Region_id =r.Region_Id where o.Region_Id is null; -- output 2
select * from output_1 where cibil_score_remark = 'High cibil score'; -- output 3
select * from output_1 where Segment in ('home office','corporate'); -- output 4


