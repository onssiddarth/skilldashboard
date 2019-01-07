# Skill-based System
This is a proof-of-concept web application demonstrating **a skill-based system for better employee engagement in a software organization**. This project is a part of my dissertation awarding *Master of Science(MSc) Information Systems with Coputing* from Dublin Business School.

## Prerequisites
* Visual Studio 2017
* SQL Server Management Studio 2017

## Getting Started
You can download the whole source code in your local folder. Execute the *GenerateDBSchema.sql* in your SQL Server Management Studio. Change the SQL connection string in the web.config of both the below application projects:
* `SkillDashboard.Web`
* `SkillDashboard.API`
<br>
Run the application in Visual Studio by pressing F5. You must see 2 instances of localhost: one for the Web API and other is the web application. Kindly replace the value of the portnumber of the below APIBaseURL key present in `SkillDashboard.Web` project's `web.config`:
`<add key="APIBaseURL" value="http://localhost:30482" />`

###### Optional Step:
After you execute the GenerateDBSchema.sql which will generate the Database and the schema for you, you can import the databse backup file *SkillDB.bak* present inside the Database folder. 

## Development Technologies and Libraries used:
* ASP.NET MVC 5, C#, SQL Server, Web API, HTML5, CSS3, JQuery, Javascript
* Bootstrap libraries
* Animate.css file
* JQuery libraries, jQuery Easy Ticker
* Highcharts
* Log4Net

## Additional Resources/References
Below video presents a conceptual framework of the skill-based system with regards to its need, features and benefits.<br>
https://www.youtube.com/watch?v=Lps_VeNJIy4

## Author
Siddarth Nair
