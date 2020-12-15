package com.yue.dao.admin;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;
import com.yue.entity.admin.Log;

@Repository
public interface LogDao {
	public List<Log> findList(Map<String, Object> queryMap);
	public int getTotal(Map<String, Object> queryMap);
	public int add(Log log);
	public int delete(String str);
}
