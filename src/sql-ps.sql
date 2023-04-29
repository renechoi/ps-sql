# 1. (SFWO)
#    문구생산부와 가구생산부의 직원정보를 확인하려한다.
# 위에 해당하는 직원들의 직원명과 입사일을 입사일이 빠른 순서대로 출력하세요.
# (문구생산부의 DNumber는 'D1001', 가구생산부는 'D2001'이며 입사일은 연,월,일까지만 출력되어야 한다)


select *
from tEmployee;

select EName as 직원명, date_format(StartDate, '%Y-%m-%d') as 입사일
from tEmployee
where DNumber = 'D1001'
   or DNumber = 'D2001'
order by StartDate asc;

select EName as 직원명, date_format(StartDate, '%Y-%m-%d') as 입사일
from tEmployee
where DNumber in ('D1001', 'D2001')
order by StartDate;


#
# 2. (SFWO)
#    2020년 크리스마스부터 입사일이 만 2년이 넘어가는 사람에게 보너스를 지급하려고 한다. 위 조건에 해당하는 직원의 직원명과 입사일을 출력하시오.
# (단, 정렬은 고려하지 않는다)


select EName as 직원명, StartDate as 입사일
from tEmployee
where TIMESTAMPDIFF(YEAR, StartDate, '2020-12-25') > 2;


# 3. (GROUP BY)
#    생산량 조정을 위해 2020년 2월의 총 생산량을 알려고 한다.
# 해당 월에 생산된 제품들의 코드와 해당 제품들의 총 생산량을 출력하시오.

select *
from tProduction;

select sum(PCount) as 총생산량, INumber as 제품코드
from tProduction
where PDate between '2020-02-01' and '2020-03-01'
group by INumber;



# 4. (GROUP BY)
#    가구류 제품들의 선호도 조사를 위하여 고객들이 가구류 제품들의 주문을 몇 번 했는지 고객코드별로 출력하시 오. (가구류의 생산코드는 P2~로 시작한다)


# 5. (GROUP BY, HAVING)
#    2020년 1월의 성실직원을 뽑기 위해 성실직원의 기준인 생산량 500개 이상을 달성한 인원들의 직원코드와 총 생산량을 출력하시오.

select ENumber as 직원번호, sum(PCount) as 총생산량
from tProduction
where PDate between '2020-01-01' and '2020-02-01'
group by ENumber
having 총생산량 > 500;



#
# 6. (CASE WHEN)
#    판매 가능한 제품들의 재고 파악을 위해 2020년 2월에 생산된 양을 확인하려하는데 우선 문구류 제품들을 먼저 파악하려 한다.
#    해당 제품명과 제품들의 총 생산량을 출력하시오.
# (문구류의 제품코드(INumber)는 I100(1~5)이며 1번은 가위, 2번은 풀, 3번은 공책, 4번은 볼펜, 5번은 지우개이다, ex - I1001 = 가위)


select (case INumber
            when 'I1001' then '가위'
            when 'I1002' then '풀'
            when 'I1003' then '공책'
            when 'I1004' then '볼펜'
            when 'I1005' then '지우개'
    end) as 문구류제품,
       PCount
from tProduction
where PDate between '2020-02-01' and '2020-03-01';


select case
           when tProduction.INumber = 'I1001' then '가위'
           when tProduction.INumber = 'I1002' then '풀'
           when tProduction.INumber = 'I1003' then '공책'
           when tProduction.INumber = 'I1004' then '볼펜'
           when tProduction.INumber = 'I1005' then '지우개'
           end     as 제품명,
       sum(PCount) as 총생산량
from tProduction
where date_format(PDate, '%Y-%m') = '2020-02'
  and substring(INumber, 1, 2) = 'I1'
group by INumber;


#
# 7. (UNION)
#    제품이 한번이라도 주문됐거나, 반품이 한번이라도 발생한 월의 정보를 알아보려고한다. 위, 조건에 해당하는 월들을 중복을 제거하고 출력하시오.

select *
from tOrder;

select *
from tReturn;


select date_format(tOrder.ODate, '%m') as 주문_및_반품월
from tOrder
group by 주문_및_반품월
union
select date_format(tReturn.RDate, '%m') as 주문_및_반품월
from tReturn
group by 주문_및_반품월;



#     8. (UNION ALL)
#        여태까지 회사에 입사했던 사람들의 총 인원 수와 연도별 입사한 직원 수를 출력하시오.


select *
from tEmployee;

select '총인원수' as 입사년도, count(*) as 입사한직원수
from tEmployee as tem1
union all
select date_format(tem2.StartDate, '%Y') as 연도, count(*)
from tEmployee as tem2
group by 연도;


#
# 9. (서브쿼리 COLUMN)
#    회사에서 제공해주는 기숙사에 머무를 수 있는 인원의 제한을 위해 부서와 직급, 그리고 현재 거주지를 따져 제한하려고 한다.
#    이에 따라 부서명과 직급명, 직원명 그리고 현재 직원의 주소를 출력하시오
# (부서코드, 직급코드가 아닌 부서명, 직급명으로 출력되어야 한다.)

select *
from tDepartment;

select *
from tEmployee;

select *
from tRank;



select (select tDepartment.DName
        from tDepartment
        where tDepartment.DNumber = tem.DNumber)                         as 부서명,
       (select tRank.RName from tRank where tRank.RNumber = tem.RNumber) as 직급명,
       tem.EAddr                                                         as 직원주소
from tEmployee as tem;


#
# 10. (서브쿼리 WHERE)
#     회사 내 전 직원들의 평균 생산량보다 한번이라도 많이 생산한 직원들에게는 상여금을 주려한다.
#     이에 해당하는 직원명을 출력하시오 (생산량은 tProduction 테이블의 PCount이다.)


select *
from tEmployee;

select *
from tProduction;

select tem.EName as 직원명
from tEmployee tem
where tem.ENumber
          in (select tpr1.ENumber
              from tProduction as tpr1
              where tpr1.PCount > (select Avg(tpr2.PCount)
                                   from tProduction tpr2));



# 12. (서브쿼리 FROM)
#     2021년부터 판매가 시작됨에 따라 지난 1년(20년 1월 1일 ~ 20년 12월 31일) 동안 생산된 제품들의 제품코드와
#     총 생산량을 생산량이 많은 순으로 확인하려한다.
#     위의 조건에 맞춰 출력하시오.


select *
from tProduction;


select tpr1.INumber as 제품코드, tpr1.PCount as 총생산량
from (select tProduction.INumber, sum(tProduction.PCount) as PCount
      from tProduction
      where tProduction.PDate between '2020-01-01' and '2020-12-31'
      group by tProduction.INumber) as tpr1
order by 총생산량 desc;


# 13. (RANK)
#     회사 내 우수직원을 생산량이 많은 직원을 기준으로 하여 상위 10명까지 뽑아 상여금을 주려한다.
# 이에 해당하는 직원들의 직원코드와 총 생산량을 상위 10명까지 순위를 매겨 출력하시오.
# (만약 공동순위(ex. 공동 1등)가 있다면 다음 순위는 중복 된 순위의 수 만큼 떨어진다.)

select *
from tProduction;


select rank() over (order by PCount desc), t1.ENumber, t1.PCount
from (select ENumber, PCount
      from tProduction
      order by PCount desc
      limit 10) as t1;



select ENumber as 직원번호, sum(PCount) as 총생산량, rank() over (order by sum(PCount) desc) as 총생산량순위
from tProduction
group by ENumber
limit 10;



#
# 14. (ROW_NUM)
#     현재 판매하는 제품들 중 장농의 인기가 많아져 판매 가능한 장농의 재고를 확인하기 위하여
# 장농 생산이력을 전부 출력하되 생산량이 높은순서대로 생산한 직원의 코드와 제품코드, 생산량을 순위를 매겨 출력하시오.
# (공동 순위가 나오지 않게 출력 해야 하며 또한 동률일경우 직원코드(ENumber)가 작은 코드가 우선순위를 가지 도록 한다, 장농의 제품코드는 I2003번이다)

select *
from tProduction;


select ENumber as 직원번호, sum(PCount) as 생산량
from tProduction
group by ENumber
order by 생산량 desc

select ENumber                                                                    as 직원번호,
       INumber                                                                    as 제품번호,
       PCount                                                                     as 생산량,
       row_number() over (PARTITION BY INumber order by PCount desc, ENumber asc) as 생산량_순위
from tProduction
where INumber = 'I2003'


#
#     15. (DENSE_RANK)
#         부서별로 연령의 평균을 파악하기 위해서 각 부서마다 속해있는 직원들의 나이로 출생연도를 알아보려한다.
# 이를 위해 부서명, 직원명, 출생연도를 출력하되 각 부서의 직원들을 출생연도가 빠른 순으로 순위를 매겨라. (공동순위는 동일하게 부여하고 그 다음 순위는 공동 순위 다음 번호로 순위가 출력되어야 하며 출생연도는 tEmplyee의 ERRN의 앞 2자리로 비교하여 출력할 수 있다. D1001 부서는 문구생산부, D2001은 가구생산부, D3001은 액세서리생산부, D4001은 전자기기생산부, D5001은 음료생산부이다.)

select case
           when DNumber = 'D1001' then '문구생산부'
           when DNumber = 'D2001' then '가구생산부'
           when DNumber = 'D3001' then '악세사리생산부'
           when DNumber = 'D4001' then '전자기기생산부'
           when DNumber = 'D5001' then '음료생산부'
           else '부서없음'
           end                                                              as 부서명,
       EName                                                                as 직원명,
       substr(ERRN, 1, 2)                                                   as 출생연도,
       dense_rank() over (partition by DNumber order by substr(ERRN, 1, 2)) as 출생연도_순위
from tEmployee;


# 16. (INNER JOIN)
#     현재까지 입사했던 모든 직원들의 직원코드, 부서명, 직원명, 직급명, 입사일, 퇴사일을 출력하시오
# (부서와 직급의 경우는 코드가 아닌 부서명과 직급명으로 출력하고 입사일과 퇴사일은 연,월,일만 출력되어야한다)


select *
from tEmployee;

select *
from tDepartment;



select ENumber as 직원번호, tDepartment.DName as 부서명, tRank.RName as 직급명, StartDate as 입사일
from tEmployee,
     tDepartment,
     tRank
where tEmployee.DNumber = tDepartment.DNumber
  and tEmployee.RNumber = tRank.RNumber


#
#
#     2021년 1월의 전자기기류 판매금 정산을 위해 전자기기류 제품들의 제품명과 해당 제품의 총 판매량을 출력하세 요. (전자기기류의 제품코드는 INumber 번호가 I4로 시작한다.)


select *
from tOrder;

select *
from tItem;

select *
from tProduction;


select tItem.IName as 제품명, count(*) as 판매량
from tItem,
     tProduction,
     tOrder
where SUBSTR(tItem.INumber, 1, 2) = 'I4'
  and tProduction.INumber = tItem.INumber
  and tOrder.PNumber = tProduction.PNumber
  and YEAR(tOrder.ODate) = 2021
  and MONTH(tOrder.ODate) = 1
group by 제품명



#     19. (INNER JOIN)
#         2022년 3월 20일 기준으로 현재 판매 가능한 공책의 재고량을 구하시오 (반품되어 돌아온 공책의 경우 재판매 하지 않는다.)

select *
from tOrder,
     tItem,
     tProduction
where tItem.IName = '공책';



SELECT tBase.IName AS "제품명", (tBase2.PCount - tBase.OCount) AS "재고량"
FROM (SELECT tit.IName, SUM(tpr.PCount) AS OCount
      FROM tProduction tpr,
           tOrder tor,
           tItem tit
      WHERE tpr.PNumber = tor.PNumber
        AND tpr.INumber = tit.INumber
        AND tit.IName = '공책'
        AND tor.ODate < '2022-03-21'
      GROUP BY tit.IName) tBase,
     (SELECT tit.IName, SUM(tpr.PCount) AS PCount
      FROM tProduction tpr,
           tItem tit
      WHERE tpr.INumber = tit.INumber
        AND tit.IName = '공책'
        AND tpr.PDate < '2022-03-21'
      GROUP BY tit.IName) tBase2
WHERE tBase.IName = tBase2.IName;


select base1.IName as 제품명, (base2.Pcount - base1.Ocount) as 재고량
from (select tItem.IName, sum(PCount) as Ocount
      from tProduction,
           tOrder,
           tItem
      where tItem.INumber = tProduction.INumber
        and tItem.IName = '공책'
        and tOrder.ODate < '2022-03-21'
        and tOrder.PNumber = tProduction.PNumber
      group by tProduction.INumber) as base1,
     (select sum(tProduction.PCount) as Pcount, tItem.IName
      from tProduction,
           tItem
      where tProduction.INumber = tItem.INumber
        and tItem.IName = '공책'
        and tProduction.PDate < '2022-03-21'
      group by tItem.IName) as base2
where base1.IName = base2.IName;



select tItem.IName, sum(PCount) as count
from tProduction,
     tOrder,
     tItem
where tItem.INumber = tProduction.INumber
  and tItem.IName = '공책'
  and tOrder.ODate < '2022-03-21'
  and tOrder.PNumber = tProduction.PNumber
group by tProduction.INumber;



# 20. (OUTER JOIN)
#     2020년 1월의 제품 별 생산량의 순위를 확인하기 위하여 제품명과 생산량을 순위를 매겨 출력하시오.
# (모든 제품이 출력되어야 하며 공동순위가 있다면 다음 순위는 공동순위의 수 만큼 밀려나고 생산되지 않은 제품 은 제일 마지막 순위로 결정되어야 한다)


select IName as 제품명, base.Pcount as 생산량, rank() over (order by base.Pcount desc) as 순위
from tItem
         left join (select INumber, sum(PCount) as Pcount
                    from tProduction
                    where YEAR(tProduction.PDate) = '2020'
                      and MONTH(tProduction.PDate) = '1'
                    group by INumber) as base
on tItem.INumber = base.INumber;


