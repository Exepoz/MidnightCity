Utils.Database = {}

function Utils.Database.execute(sql,params)
	MySQL.Sync.execute(sql, params)
end

function Utils.Database.fetchAll(sql,params)
	return MySQL.Sync.fetchAll(sql, params)
end

function Utils.Database.validateTableColumns(tables, add_column_sqls, change_table_sqls)
	for table, columns in pairs(tables) do
		if Config.disable_column_check == true then
			local columns_str = "";
			for i, column in pairs(columns) do
				if i == 1 then
					columns_str = columns_str.."`"..column.."`";
				else
					columns_str = columns_str..", `"..column.."`";
				end
			end
			local sql = "SELECT "..columns_str.." FROM `"..table.."` LIMIT 1";
			local query_2 = Utils.Database.fetchAll(sql,{});
			if query_2 == nil then
				error("^1["..GetInvokingResource().."]^3 The table^1"..table.."^3 has some missing columns. Please, delete this table \"^1"..table.."^3\" and restart the server.^7")
			end
		else
			local sql = "SELECT COLUMN_TYPE, DATA_TYPE, COLUMN_NAME, COLUMN_DEFAULT, IS_NULLABLE FROM `information_schema`.`COLUMNS` WHERE TABLE_SCHEMA = (SELECT DATABASE() AS default_schema) and TABLE_NAME='"..table.."' ORDER BY ORDINAL_POSITION;";
			local query_information_schema = Utils.Database.fetchAll(sql,{});
			for _, column in pairs(columns) do
				local column_found = false
				for k, column_data in pairs(query_information_schema) do
					if column == column_data.COLUMN_NAME then
						column_found = true
						checkExistingColumnType(table,column,column_data,change_table_sqls)
					end
				end
				if column_found == false then
					fixMissingColumn(table,column,add_column_sqls)
				end
			end
		end
	end
end

function fixMissingColumn(table_name, column_name, add_column_sqls)
	if add_column_sqls and add_column_sqls[table_name] and add_column_sqls[table_name][column_name] then
		Utils.Database.execute(add_column_sqls[table_name][column_name])
	else
		error("^1["..GetInvokingResource().."]^3 The table ^1"..table_name.."^3 has some missing columns. Please, delete this table \"^1"..table_name.."^3\" and restart the server.^7")
	end
end

function checkExistingColumnType(table_name, column_name, column_data, change_table_sqls)
	if change_table_sqls and change_table_sqls[table_name] and change_table_sqls[table_name][column_name] then
		local change_table_sql = change_table_sqls[table_name][column_name]
		local is_outdated = false
		for k, v in pairs(column_data) do
			if change_table_sql[k] ~= v then
				is_outdated = true
			end
		end
		if is_outdated then
			Utils.Database.execute(change_table_sql.sql)
		end
	end
end