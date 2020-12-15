package com.yue.service.admin.impl;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.yue.dao.admin.LogDao;
import com.yue.entity.admin.Log;
import com.yue.service.admin.LogService;

@Service
public class LogServiceImpl implements LogService {
	@Autowired
	private LogDao logDao;
	
	@Override
	public List<Log> findList(Map<String, Object> queryMap) {
		return logDao.findList(queryMap);
	}

	@Override
	public int getTotal(Map<String, Object> queryMap) {
		return logDao.getTotal(queryMap);
	}
	@Override
	public int delete(String str) {
		return logDao.delete(str);
	}

	@Override
	public int add(String content) {
		Log log = new Log();
		log.setContent(content);
		log.setTime(new Date());
		return logDao.add(log);
	}
}
