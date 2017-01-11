using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using MsSqlEventStore.Domain;
using MsSqlEventStore.Utils;

namespace MsSqlEventStore
{
    class Program
    {
        static void Main(string[] args)
        {
            using (SqlConnection sqlConnection = new SqlConnection("Server=(local);DataBase=EventStore;Integrated Security=SSPI"))
            {
                //// x2 events
                //var eventsToBeInserted = new List<Event>
                //{
                //        new Event()
                //        {
                //            Version = 0,
                //            Data = ProtoSerializer.Serialize("event1"),
                //            Date = DateTime.Now
                //        },
                //        new Event()
                //        {
                //            Version = 0,
                //            Data = ProtoSerializer.Serialize("event2"),
                //            Date = DateTime.Now
                //        }
                //};

                // x10 events
                var eventsToBeInserted = new List<Event>
                {
                        new Event()
                        {
                            Version = 0,
                            Data = ProtoSerializer.Serialize("event1"),
                            Date = DateTime.Now
                        },
                        new Event()
                        {
                            Version = 0,
                            Data = ProtoSerializer.Serialize("event2"),
                            Date = DateTime.Now
                        },
                        new Event()
                        {
                            Version = 0,
                            Data = ProtoSerializer.Serialize("event3"),
                            Date = DateTime.Now
                        },
                        new Event()
                        {
                            Version = 0,
                            Data = ProtoSerializer.Serialize("event4"),
                            Date = DateTime.Now
                        },
                        new Event()
                        {
                            Version = 0,
                            Data = ProtoSerializer.Serialize("event5"),
                            Date = DateTime.Now
                        },new Event()
                        {
                            Version = 0,
                            Data = ProtoSerializer.Serialize("event6"),
                            Date = DateTime.Now
                        },
                        new Event()
                        {
                            Version = 0,
                            Data = ProtoSerializer.Serialize("event7"),
                            Date = DateTime.Now
                        },new Event()
                        {
                            Version = 0,
                            Data = ProtoSerializer.Serialize("event8"),
                            Date = DateTime.Now
                        },
                        new Event()
                        {
                            Version = 0,
                            Data = ProtoSerializer.Serialize("event9"),
                            Date = DateTime.Now
                        },new Event()
                        {
                            Version = 0,
                            Data = ProtoSerializer.Serialize("event10"),
                            Date = DateTime.Now
                        }
                };

                sqlConnection.Open();

                for (int i = 0; i < 10; ++i)
                {
                    int expectedVersion = 1;
                    Guid aggregateId = Guid.NewGuid(); //new Guid("0eaf40de-6481-4895-a654-e6bea1c6a594");

                    foreach (var e in eventsToBeInserted)
                        e.AggregateId = aggregateId;

                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.CommandText = "dbo.SaveEvents";
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.Connection = sqlConnection;
                        
                        PrepareParameters(cmd, aggregateId, expectedVersion,
                            eventsToBeInserted);

                        cmd.ExecuteNonQuery();
                    }
                }
            }

            Console.WriteLine("Work done.");
        }

        private static void PrepareParameters(SqlCommand command, Guid aggregateId, int expectedVersion, List<Event> events)
        {
            var userDefinedTable = new DataTable();
            userDefinedTable.Columns.Add("AggregateId", typeof(Guid));
            userDefinedTable.Columns.Add("Data", typeof(byte[]));
            userDefinedTable.Columns.Add("Version", typeof(int));
            userDefinedTable.Columns.Add("Date", typeof(DateTime));

            foreach (var e in events)
                userDefinedTable.Rows.Add(e.AggregateId, e.Data, e.Version, e.Date);

            SqlParameter parameter = command.Parameters.AddWithValue("@Events", userDefinedTable);
            parameter.SqlDbType = SqlDbType.Structured;
            parameter.TypeName = "dbo.EventType";

            parameter = command.Parameters.AddWithValue("@ExpectedVersion", expectedVersion);
            parameter.SqlDbType = SqlDbType.Int;

            parameter = command.Parameters.AddWithValue("@AggregatedId", aggregateId);
            parameter.SqlDbType = SqlDbType.UniqueIdentifier;
        }
    }
}
