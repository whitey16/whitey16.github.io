use dbd

  IF OBJECT_ID('tempdb..#femaleFounder') IS NOT NULL		DROP TABLE #femaleFounder
  IF OBJECT_ID('tempdb..#vcRound') IS NOT NULL				DROP TABLE #vcRound
  IF OBJECT_ID('tempdb..#vcraisedtodate') IS NOT NULL		DROP TABLE #vcraisedtodate

select distinct
be.pbID
,count(distinct(case 
	when pe.Gender = 2 THEN pe.pbID
	when pe.Gender is NULL AND pe.Prefix = 74 THEN pe.pbID
	end)) AS [Female Founder Count]
,count(distinct(case 
	when pe.Gender = 1 THEN pe.pbID
	when pe.Gender is NULL AND pe.Prefix = 73 THEN pe.pbID
	end)) AS [Male Founder Count]
,COUNT(DISTINCT pe.entityid) AS [Total Founder Count]

into  #femaleFounder

from BusinessEntity be
inner join EntityManagement em ON em.BusinessEntityId = be.EntityID
inner join PersonEntity pe ON em.PersonID = pe.EntityID
	and pe.FirstName not LIKE '[_]%'
	and pe.FirstName not LIKE '[_]%'
	and pe.publishStatusId = 1
left join InvestorTitle it ON it.ID = em.PositionID
left join InvestorTitle it2 ON it2.ID = em.PositionID2

where
it.ID IN (42,43) 
OR it2.ID IN (42,43)
OR em.TitleFull LIKE '%founder%'
OR em.FounderYN = 1

group by be.pbID

select 
be.pbid AS [Company PBID]
,be.entityname AS [Company Name]
,tf.EntityID AS [Round ID]
,tf.financingid AS [Round #]
,tf.CloseDate AS [Round Date]
,tf.TotalAmountRaised / cer.rate AS [Deal Size USD]
,tf.PostValue / cer.rate as [Post Value USD]
,ROW_NUMBER() over(partition by be.entityid order by tf.financingid desc) AS [VC Deal Number Descending]

into #vcRound

from BusinessEntity be
inner join TargetCompany tc ON tc.BusinessEntityId = be.EntityID		
inner join TargetFinancing tf ON tf.businessEntity = be.EntityID
	AND tf.CurrentFinancingStatus = 11 --ROUND SET TO CLOSE
	and tf.publishstatusfull != 3 --ROUND SET TO PUBLISH
inner join FinancingTypeNew ftn ON ftn.ID = tf.newFinancingType1

inner join FinancingStatus fstf ON fstf.ID = tf.financingStatus
left join CurrencyExchangeRate cer ON cer.id = (SELECT TOP 1 cer1.id 
												FROM CurrencyExchangeRate cer1 
                                                WHERE cer1.sourceCurrency = tf.CurrencyCode 
                                                AND cer1.[date] <= tf.CloseDate 
                                                ORDER BY cer1.[date] DESC)
where
tf.PostValue is not null --for getting most recent valuation

select vcr.[Round ID]
	,vcr.[Round #]
	,SUM(vcr.[Deal Size USD]) AS [VC Raised to Date]
INTO #vcraisedtodate
from #vcRound vcr
GROUP BY vcr.[Round ID]
		,vcr.[Round #]
HAVING vcr.[Round #] <= vcr.[Round #]

/*==========================================*/				
/*--------MAIN QUERY STARTS HERE------------*/
/*==========================================*/	
select
/*these top fields are ordered/formatted to make them easy to use for top deals; many of the fields are duplicates of others
in the query but have different header names to not disrupt the Pivot tables in the master data files*/
be.EntityName AS [companyName]
--,pic.ImageName -- HOW CAN WE USE THIS?
,(select top 1 vcr.[Post Value USD]
	from #vcRound vcr
	where
	vcr.[Company PBID] = be.pbID
	order by
	vcr.[Round #] desc) AS [mostRecentValuation]
,(select sum(vcr.[Deal Size USD])
	from #vcRound vcr
	where
	vcr.[Company PBID] = be.pbID) AS [totalCapitalRaised]
,(case
	when cc.ID = 1 then es.City + ', ' + stat.ShortDescription
	else es.City + ', ' + cc.Description
end) AS [location]
,cod.Description AS [industryCode]
,'https://my.pitchbook.com/?c='+be.pbid AS [companyUrl]
----------end formatted fields-----------

from BusinessEntity be
inner join TargetCompany tc ON tc.BusinessEntityId = be.EntityID
	and tc.publishStatus = 1 --COMPANY TAB SET TO PUBLISH
	and be.EntityName NOT LIKE '[_]%' --NO DNU ENTITIES
	and be.EntityName NOT LIKE 'for-test %' --NO TEST ENTITIES
--left join Picture pic ON pic.TargetEntityId = be.EntityID

inner join EntitySite es ON es.BusinessEntityId = be.EntityID
	and es.SiteStatus = 1 --CURRENT SITE
	and es.SiteType = 1 --PRIMARY HQ
left join State stat ON stat.ID = es.State
inner join CountryCode cc ON cc.ID = es.countryCode

inner join NewIndustryPath nip ON nip.companyEntityId = tc.EntityID
	and nip.primaryIndustry = 1 --PRIMARY INDUSTRY ONLY
inner join PbIndustrySector sec ON sec.ID = nip.industrySector
inner join PbIndustryGroup grp ON grp.ID = nip.industryGroup
inner join PbIndustryCode cod ON cod.ID = nip.industryCode

left join #femaleFounder ff ON ff.pbID = be.pbID

where
be.pbID IN ('88111-54','56914-48','53373-34','55780-93','99446-23','50894-65','13329-91','130185-82','114111-82','53676-19','46488-07','53664-49','151193-08','64334-26','123107-05','54280-18','59959-27','53898-76','53913-70','50877-91','55268-20','61371-46','52379-92','114455-53','181930-42','101664-91','54490-06','101954-80','123265-18','51037-75','186851-17','51777-73','152144-11','62506-63','51081-40','58165-57','59077-90','221636-98','62181-28','42936-49','156477-16','83810-17','157653-46','40997-08','61666-75','184805-74','63953-65','63628-21','54220-78','55815-22','58942-45','166639-96','124214-50','58626-46','13464-82','51481-09','53903-53','59191-48','91141-75','58137-31','126395-56','54020-62','52833-61','51389-56','53637-58','164275-03','61010-65','162767-89','51270-13','52686-01','52950-43','124585-12','113273-20','51146-47','51527-08','113107-96','56125-36','64152-28','61931-08','51156-64','121683-34','39605-77','53780-77','44157-88','118715-14','110488-87','56174-23','57227-95','180241-75','53351-38','56091-25','51136-75','54484-48','179690-41','52598-44','118455-94','51145-39','54782-29','44161-48','97131-16','53833-15','54846-28','55446-58','51261-67','164391-31','55633-60','61828-75','56017-63','54188-02','54595-54','56962-45','54162-82','157027-87','110556-19','99587-80','169415-83','56120-32','120626-92','54401-59','64708-30','43117-84','54783-19','58369-06','43013-80','160140-70','81712-36','150697-72','55865-53','51071-77','120764-17','62283-07','107002-72','52814-62','51074-47','107572-24','60490-00','62180-65','108715-69','139892-68','183108-88','62425-45','52304-77','55758-97','63620-65','54192-97','58466-89','57184-93','54764-56','66083-95','54284-77','40463-74','40666-24','129054-79','42170-68','54451-45','58111-93','58034-35','98324-20','98273-44','181877-86','56343-97','55767-07','93537-46','42166-63','51639-31','43076-44','54573-94','42964-93','55513-00','112268-08','54332-38','111620-71','54606-61','51655-06','58101-13','112289-68','52142-14','54275-77','56851-12','53601-76','52368-49','54112-06','44794-54','51657-49','51252-85','55123-66','54525-52','55108-72','55329-40','57271-15','52232-23','53629-75','52702-39','51736-87','114429-16','66264-67','112711-24','56149-21','52838-11','51401-80','54072-19','42881-32','54943-03','82010-80','56161-63','51420-07','54371-08','92462-32','53301-43','51502-96','42706-63','65745-19','51676-66','52275-43','53597-62','52514-65','43028-47','51586-57','55300-06','55554-85','42935-95','98622-91','52241-32','11020-15','56944-45','103072-60','58885-39')


for json path, root('companies')