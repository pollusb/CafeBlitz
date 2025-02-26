# CafeBlitz

A wrapper for the First Responder Kit

This code was build to ease First Responder Kit (FRK) calls. If you don't know anything about it, you should first take a look at [FRK on GitHub](https://github.com/BrentOzarULTD/SQL-Server-First-Responder-Kit/releases).

## 1. No deployement approach

FRK package comes in the form of TSQL stored procedures. They need to be deployed in either master or a user database. Deploying FRK on multiple SQL Server instances can be difficult for some. We use a no deployment approach.

When you run the PowerShell functions from this module, it creates a temporary stored procedure then use it. The result can be looked at the console, dumped into a XML file or Excel file. This provide many benefits:

- The consolidated result will all be using the same logic, the same version.
- Using PowerShell make it easier to export the result to a file. So you can ask someone to run it for you then send you the output.
- You can keep track of past executions to compare with newer ones without bloating the client databases.
- You can consume the result into a pipeline to extract insights to resolve performance issues.

## 2. Export results

Sometimes, you need someone else to run the script then send you the results. You can consume data manually or via a pipeline to advise your client.

The columns in FRK are oriented towards showing in SSMS. We renamed them to ease object oriented programming (no space or special caracters)
