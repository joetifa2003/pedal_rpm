import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';

part 'model.g.dart';

const tableBike = SqfEntityTable(
  tableName: "bike",
  primaryKeyName: "id",
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  fields: [
    SqfEntityField("name", DbType.text),
    SqfEntityField("tire", DbType.real)
  ],
);

const tableGear = SqfEntityTable(
  tableName: "gear",
  primaryKeyName: "id",
  primaryKeyType: PrimaryKeyType.integer_auto_incremental,
  fields: [
    SqfEntityFieldRelationship(
      parentTable: tableBike,
      deleteRule: DeleteRule.CASCADE,
      fieldName: "bike_id",
    ),
    SqfEntityField("gear", DbType.integer),
    SqfEntityField("teath", DbType.integer),
    SqfEntityField("type", DbType.text),
  ],
);

const seqIdentity = SqfEntitySequence(
  sequenceName: 'identity',
);

@SqfEntityBuilder(myDbModel)
const myDbModel = SqfEntityModel(
  modelName: 'DBModel',
  databaseName: 'pedal.db',
  databaseTables: [tableBike, tableGear],
  sequences: [seqIdentity],
  bundledDatabasePath: null,
);
