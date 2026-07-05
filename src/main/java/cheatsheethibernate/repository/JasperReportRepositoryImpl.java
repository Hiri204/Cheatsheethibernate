package cheatsheethibernate.repository;

import cheatsheethibernate.repository.JasperReportRepository;
import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.hibernate.query.NativeQuery;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public class JasperReportRepositoryImpl implements JasperReportRepository {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public List<Object[]> getReportData(Integer year, Integer month) {
        Session session = sessionFactory.getCurrentSession();
        
        NativeQuery<Object[]> query = session.createNativeQuery(
            "CALL sp_get_cheatsheet_report(:p_year, :p_month)"
        );
        query.setParameter("p_year", year);
        query.setParameter("p_month", month);
        
        return query.getResultList();
    }

    @Override
    public Object[] getReportSummary(Integer year, Integer month) {
        Session session = sessionFactory.getCurrentSession();
        
        NativeQuery<Object[]> query = session.createNativeQuery(
            "CALL sp_get_cheatsheet_report_summary(:p_year, :p_month)"
        );
        query.setParameter("p_year", year);
        query.setParameter("p_month", month);
        
        return query.getSingleResult();
    }
}