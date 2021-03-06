public with sharing class XP_ExperienceController {
    public XP_ExperienceController() {

    }

    @AuraEnabled
   public static xpWrapper fetchPreviewInfo(string xpId){

    xpWrapper  xpWrap = new xpWrapper();
    List<Experience__c> xp = [select Name, Account__c, Journey__c,DateScheduled__c from Experience__c where Id = :xpId];

    List<Account_xp__c> xpA = [select Id, Name, Name__c from Account_xp__c where Id= :xp[0].Account__c];
    Integer xpC_count = [select count() from XP_Contact__c where account__c = :xp[0].Account__c]; 

    List<Journey__c> xpJ = [select Id, Name, Description__c,Journey_Id__c from Journey__c where Id =: xp[0].Journey__c];

    xpWrap.xpName = xpJ[0].Name;
    xpWrap.xpKey = xpJ[0].Journey_Id__c;
    xpWrap.accName = xpA[0].Name;
    xpWrap.noOfParticipants = xpC_count;
    xpWrap.startDateTime = xp[0].DateScheduled__c;

    return xpWrap;
   }

   @AuraEnabled
   public static void scheduleJourney(Date scheduleDate, string xpId){

    //String[] dateArray = scheduleDate.split(';');

    List<Experience__c> xp = [select Status__c, DateScheduled__c from Experience__c where Id = :xpId];

    //xp[0].DateScheduled__c = datetime.newInstance(Integer.valueOf(dateArray[0]), Integer.valueOf(dateArray[1]), Integer.valueOf(dateArray[2]), Integer.valueOf(dateArray[3]), Integer.valueOf(dateArray[4]), Integer.valueOf(dateArray[5]));
    xp[0].DateScheduled__c = scheduleDate;
    xp[0].Status__c = 'Scheduled';

    update xp;

   }

    public class xpWrapper {

        @AuraEnabled
        public String xpName {get; set;}

        @AuraEnabled
        public String xpKey {get; set;}

        @AuraEnabled
        public String accName {get; set;}

        @AuraEnabled
        public Datetime startDateTime {get; set;}

        @AuraEnabled
        public Integer noOfParticipants {get; set;}

    }
}
