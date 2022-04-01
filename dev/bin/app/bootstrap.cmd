@echo off

@rem
@rem @rem Licensed to the Apache Software Foundation (ASF) under one or more
@rem @rem contributor license agreements.  See the NOTICE file distributed with
@rem @rem this work for additional information regarding copyright ownership.
@rem @rem The ASF licenses this file to You under the Apache License, Version 2.0
@rem @rem (the "License"); you may not use this file except in compliance with
@rem @rem the License.  You may obtain a copy of the License at
@rem @rem
@rem @rem     http://www.apache.org/licenses/LICENSE-2.0
@rem @rem
@rem @rem Unless required by applicable law or agreed to in writing, software
@rem @rem distributed under the License is distributed on an "AS IS" BASIS,
@rem @rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem @rem See the License for the specific language governing permissions and
@rem @rem limitations under the License.
@rem

set base=%~dp0%\..\

java -classpath %base%\main\streamingpro-mlsql-spark_3.0_2.12-2.3.0-SNAPSHOT.jar;%base%\spark\*;%base%\libs\*;%base%\plugin\*; tech.mlsql.example.app.LocalSparkServiceApp -streaming.plugin.clzznames tech.mlsql.plugins.ds.MLSQLExcelApp,tech.mlsql.plugins.assert.app.MLSQLAssert,tech.mlsql.plugins.shell.app.MLSQLShell,tech.mlsql.plugins.ext.ets.app.MLSQLETApp,tech.mlsql.plugins.mllib.app.MLSQLMllib
