create database banks_portal;
use banks_portal;
create table Accounts
(
	accountId int not null unique auto_increment,
    ownerName varchar(45) not null,
    owner_ssn int not null,
    balance decimal(10,2) default 0.00,
    account_status varchar(45)
);

alter table Accounts
add Primary key (accountId);

create table IF not exists Transactions (
	transactionId int not null unique auto_increment primary key, 
	accountId int not null,
	transactionType varchar(45) not null,
	transactionAmount decimal(10,2) not null
);

Insert into Accounts (ownerName, owner_ssn, balance, account_status)
values
('Maria Jozef', 123456789, 10000.00, 'active'),
('Linda Jones', 987654321, 2600.00, 'inactive'),
('John McGrail', 222222222, 100.50, 'active'),
('Patty Luna', 111111111, 509.75, 'inactive');

Insert into Transactions (accountId, transactionType, transactionAmount)
values
(1, 'deposit', 650.98), 
(3, 'withdraw', 899.87),
(3, 'deposit', 350.00);

Delimiter //
Create procedure accountTransactions(in accountId int)
begin
	select * from transactions
    where accountId = accountId;
End//
Delimiter ;

Delimiter //
Create procedure deposit(in accountId int, amount decimal(10,2))
Begin
	Start Transaction;
    Insert into Transactions ( accountId, transactionType, transactionAmount)
    value (accountId, 'deposit', amount);
	
    update accounts
    set balance = balance + amount
    where accountId = accountId;
    
    commit;
End//
Delimiter ;

Delimiter //
Create procedure withdraw(in accountId int, amount decimal(10,2))
Begin
	declare currentBalance decimal(10,2);
    start transaction;
    select balance into currentBalance from accounts where accountId = accountId;
    
    If currentBalance >= amount Then 
		insert into Transacations (accountId, transactionType, transactionAmount)
		values (accountId, 'withdraw', amount);
        
        update accounts
        set balance = balance - amount
        where accountId = accountId;
        
        commit;
        SELECT 1 as Status, 'Transaction successful' as Message;
	Else
		Rollback;
         SELECT 0 as Status, 'Insufficient balance' as Message;
	End If;
End //
Delimiter ;

Delimiter //
Create Procedure deleteAccount(in accountId int)
Begin
	DELETE FROM Accounts WHERE accountId = accountId;
End//
Delimiter ;
    
Delimiter //
CREATE Procedure addAccount(IN ownerName varchar(45), IN owner_ssn INT, IN balance DECIMAL(10,2),  account_status varchar(45))
BEGIN
    INSERT INTO accounts (ownerName, owner_ssn, balance, account_status) 
    VALUES (ownerName, owner_ssn, balance, account_status);
END //
DELIMITER ;
    
DELIMITER //
CREATE PROCEDURE GetAllTransactions()
BEGIN
  SELECT * FROM Transactions;
END //
DELIMITER ;