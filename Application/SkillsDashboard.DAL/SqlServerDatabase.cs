using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web;

namespace SkillsDashboard.DAL
{
    public class SqlServerDatabase : IDatabase
    {
        private string ConnectionString { get; set; }

        public SqlServerDatabase(string argConnectionString)
        {
            ConnectionString = argConnectionString;
        }

        public IDbConnection CreateConnection()
        {
            return new SqlConnection(ConnectionString);
        }

        public void CloseConnection(IDbConnection argConnection)
        {
            var sqlConnection = (SqlConnection)argConnection;
            sqlConnection.Close();
            sqlConnection.Dispose();
        }

        public IDbCommand CreateCommand(string argCommandText, CommandType argCommandType, IDbConnection argConnection)
        {
            return new SqlCommand
            {
                CommandText = argCommandText,
                Connection = (SqlConnection)argConnection,
                CommandType = argCommandType
            };
        }

        public IDataAdapter CreateAdapter(IDbCommand argCommand)
        {
            return new SqlDataAdapter((SqlCommand)argCommand);
        }

        public IDbDataParameter CreateParameter(IDbCommand argCommand)
        {
            SqlCommand SQLcommand = (SqlCommand)argCommand;
            return SQLcommand.CreateParameter();
        }

    }
}