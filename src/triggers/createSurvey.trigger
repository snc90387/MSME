trigger createSurvey on Contact (after insert) 
{

    List<survey__c> survey = new List<survey__c>();

    
    for (Contact con: Trigger.New)
    {
        
            survey.add(new survey__c(
                        Name = con.Name,
                        contactToSurvey__c = con.id ));
    }
        insert survey ;
}