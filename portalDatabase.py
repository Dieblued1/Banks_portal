import mysql.connector
from mysql.connector import Error


class Database():
    def __init__(self,
                 host="127.0.0.1",
                 port="3306",
                 database="banks_portal",
                 user='root',
                 password='Password'):

        self.host       = host
        self.port       = port
        self.database   = database
        self.user       = user
        self.password   = password
        self.connection = None
        self.cursor     = None
        self.connect()

    def connect(self):
        try:
            self.connection = mysql.connector.connect(
                host         = self.host,
                port         = self.port,
                database     = self.database,
                user         = self.user,
                password     = self.password)
            
            if self.connection.is_connected():
                return
        except Error as e:
            print("Error while connecting to MySQL", e)


    def getAllAccounts(self):
        if self.connection.is_connected():
            self.cursor= self.connection.cursor()
            query = "select * from accounts"
            self.cursor.execute(query)
            records = self.cursor.fetchall()
            return records

    def getAllTransactions(self):
        self.cursor.callproc('GetAllTransactions')
        results = self.cursor.stored_results()

        transactions = []
        for result in results:
            transactions = result.fetchall()
    
        return transactions
       
    def deposit(self, accountID, amount):
        if self.connection.is_connected():
            self.cursor = self.connection.cursor()
            query = "CALL deposit(%s, %s)"
            self.cursor.execute(query, (accountID, amount))
            self.connection.commit()
   

    def withdraw(self, accountID, amount):
         if self.connection.is_connected():
              self.cursor = self.connection.cursor()
              query = "CALL withdraw(%s, %s)"
              self.cursor.execute(query, (accountID, amount))
              result = self.cursor.fetchone()
              if result[0] == 0:
                   print(f"Error: {result[0]}")
              else:
                self.connection.commit()
                print("{result[1]}")
        
    def addAccount(self, ownerName, owner_ssn, balance, status):
        if self.connection.is_connected():
           self.cursor = self.connection.cursor()
           query = "CALL addAccount(%s, %s, %s, %s)"
           self.cursor.execute(query, (ownerName, owner_ssn, balance, status))
           self.connection.commit()
  
    def accountTransactions(self, accountID):
         if self.connection.is_connected():
            self.cursor = self.connection.cursor()
            query = "CALL accountTransactions(%s)"
            self.cursor.execute(query, (accountID,))
            records = self.cursor.fetchall()
            return records
  
    def deleteAccount(self, AccountID):
        if self.connection.is_connected():
            self.cursor = self.connection.cursor()
            query = "CALL deleteAccount(%s)"
            self.cursor.execute(query, (AccountID,))
            self.connection.commit()
        
        
        
    
    
