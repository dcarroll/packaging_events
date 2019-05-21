public with sharing class SlackNotification {

    // @InvocableMethod(label='Send Slack Notification' description='Send a slack notification to the red account channel.')
    @future(callout='true')
    public static void sendSlackNotification(List<String> messages) {
        Slack_Values__mdt sv = [Select Token__c From Slack_Values__mdt Where DeveloperName = 'Daves'];
        String token = sv.Token__c;
        for (String msg : messages) {
            Http h = new Http();
            HttpRequest req = new HttpRequest();
            req.setEndpoint('https://slack.com/api/chat.postMessage');
            req.setMethod('POST');
            req.setHeader('Authorization', 'Bearer ' + token);
            req.setHeader('Content-type', 'application/json');
            JSONGenerator gen = JSON.createGenerator(true);
            gen.writeStartObject();
            gen.writeStringField('channel', 'hackerzone');
            gen.writeStringField('text', msg);
            gen.writeEndObject();
            String body = gen.getAsString();
            req.setBody(body);
            System.debug(req.getBody());
            HttpResponse res = h.send(req);
            System.debug(res.getBody());
        }
    }
}