insert into members (full_name, membership_type,monthly_fee,join_date,,status,renewal_date)
values ('Sarah Jonhson', 'Premium',89.99,current_date, 'Active'),
       ('“Mike	Chen','Basic',49.99,current_date,'Active');

insert into gym_class(class_name,instructor_name,max_capacity,current_enrolled,class_fee)
values ('dvanced	Yoga','Liza',25,0, 15*1.3)

insert into members (full_name, membership_type,monthly_fee,join_date,,status,renewal_date)
values ('Trial	Member',NULL,NULL,current_date,'Trial');

update members set monthly_fee = monthly_fee * 1.12 where membership_type = 'Premium';


update members set status =
    case when monthly_fee > 70 then 'VIP'
    when monthly_fee between 40 and 70 then 'Regular'
    else 'Basic'
end ;

update gym_class set current_unlorred = current_unlorred+1 where id =5;


update members set monthly_fee * 0.5 ,membership_type = 'Suspended' where stasus = 'Inactive';


delete from members where status = 'Inactive' and join_date < '2023-01-01';

delete from gym_classes where current_enrolled = 0 and charge > 50;

delete from booking where attendance_status = 'No-Show'
returning booking_is, member_id;

update members set renewel_date = NULL where membership_type IS NULL
returning member_id, full_name;

delete from booking where member_id in (select number_id from members where status = 'Active')
returning  booking_is, member_id;
