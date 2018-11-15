﻿using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace SkillsDashboard.DAL
{
    public class SkillsDBManager
    {
        private DatabaseFactory _dbFactory;
        private IDatabase _database;
        private string _providerName;

        public SkillsDBManager(string argConnectionStringName)
        {
            _dbFactory = new DatabaseFactory(argConnectionStringName);
            _database = _dbFactory.CreateDatabase();
            _providerName = _dbFactory.GetProviderName();
        }

        public IDbConnection GetDatabasecOnnection()
        {
            return _database.CreateConnection();
        }

        public void CloseConnection(IDbConnection argConnection)
        {
            _database.CloseConnection(argConnection);
        }

        public IDbDataParameter CreateParameter(string argName, object argValue, DbType argDbType)
        {
            return DatabaseParameter.CreateParameter(_providerName, argName, argValue, argDbType, ParameterDirection.Input);
        }

        public IDbDataParameter CreateParameter(string argName, int argSize, object argValue, DbType argDbType)
        {
            return DatabaseParameter.CreateParameter(_providerName, argName, argSize, argValue, argDbType, ParameterDirection.Input);
        }

        public IDbDataParameter CreateParameter(string argName, int argSize, object argValue, DbType argDbType, ParameterDirection direction)
        {
            return DatabaseParameter.CreateParameter(_providerName, argName, argSize, argValue, argDbType, direction);
        }

        public DataTable GetDataTable(string argCommandText, CommandType argCommandType, IDbDataParameter[] argParameters = null)
        {
            using (var connection = _database.CreateConnection())
            {
                connection.Open();

                using (var command = _database.CreateCommand(argCommandText, argCommandType, connection))
                {
                    if (argParameters != null)
                    {
                        foreach (var parameter in argParameters)
                        {
                            command.Parameters.Add(parameter);
                        }
                    }

                    var dataset = new DataSet();
                    var dataAdaper = _database.CreateAdapter(command);
                    dataAdaper.Fill(dataset);

                    return dataset.Tables[0];
                }
            }
        }

        public DataSet GetDataSet(string argCommandText, CommandType argCommandType, IDbDataParameter[] argParameters = null)
        {
            using (var connection = _database.CreateConnection())
            {
                connection.Open();

                using (var command = _database.CreateCommand(argCommandText, argCommandType, connection))
                {
                    if (argParameters != null)
                    {
                        foreach (var parameter in argParameters)
                        {
                            command.Parameters.Add(parameter);
                        }
                    }

                    var dataset = new DataSet();
                    var dataAdaper = _database.CreateAdapter(command);
                    dataAdaper.Fill(dataset);

                    return dataset;
                }
            }
        }

        public void Delete(string argCommandText, CommandType argCommandType, IDbDataParameter[] argParameters = null)
        {
            using (var connection = _database.CreateConnection())
            {
                connection.Open();

                using (var command = _database.CreateCommand(argCommandText, argCommandType, connection))
                {
                    if (argParameters != null)
                    {
                        foreach (var parameter in argParameters)
                        {
                            command.Parameters.Add(parameter);
                        }
                    }

                    command.ExecuteNonQuery();
                }
            }
        }

        public void Insert(string argCommandText, CommandType argCommandType, IDbDataParameter[] argParameters)
        {
            using (var connection = _database.CreateConnection())
            {
                connection.Open();

                using (var command = _database.CreateCommand(argCommandText, argCommandType, connection))
                {
                    if (argParameters != null)
                    {
                        foreach (var parameter in argParameters)
                        {
                            command.Parameters.Add(parameter);
                        }
                    }

                    command.ExecuteNonQuery();
                }
            }
        }

        public int Insert(string argCommandText, CommandType argCommandType, IDbDataParameter[] argParameters, out int argLastId)
        {
            argLastId = 0;
            using (var connection = _database.CreateConnection())
            {
                connection.Open();

                using (var command = _database.CreateCommand(argCommandText, argCommandType, connection))
                {
                    if (argParameters != null)
                    {
                        foreach (var parameter in argParameters)
                        {
                            command.Parameters.Add(parameter);
                        }
                    }

                    object newId = command.ExecuteScalar();
                    argLastId = Convert.ToInt32(newId);
                }
            }

            return argLastId;
        }

        public void Update(string argCommandText, CommandType argCommandType, IDbDataParameter[] argParameters)
        {
            using (var connection = _database.CreateConnection())
            {
                connection.Open();

                using (var command = _database.CreateCommand(argCommandText, argCommandType, connection))
                {
                    if (argParameters != null)
                    {
                        foreach (var parameter in argParameters)
                        {
                            command.Parameters.Add(parameter);
                        }
                    }

                    command.ExecuteNonQuery();
                }
            }
        }
    }
}