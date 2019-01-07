# Employee Skill Dashboard
This is a prof-of-concept web application demonstrating a skill-based system for better employee engagement in a software organization.

## Prerequisites
* .NET framework 4.6
* Visual Studio 2017
* SQL Server Management Studio 2017

## Getting Started
You can download the whole source code in your local folder. Execute the GenerateDBSchema.sql in your SQL Server Management Studio. Change the SQL connection string in the web.config of both the below application projects:
* SkillDashboard.Web
* SkillDashboard.API
Run the application in Visual Studio by pressing F5. You must see 2 instances of localhost: one for the Web API and other is the web application. Kindly replace the value of the portnumber of the below APIBaseURL key present in 'SkillDashboard.Web' project's web.config:
<add key="APIBaseURL" value="http://localhost:30482" />

## Development Technologies and Libraries used:
* ASP.NET MVC 5, C#, SQL Server, Web API, HTML5, CSS3, JQuery, Javascript
* Bootstrap libraries
* Animate.css file
* JQuery libraries, jQuery Easy Ticker
* Highcharts
* Log4Net

## Author
Siddarth Nair
