/**
 * Created by gerry on 1/30/2021.
 */

public with sharing class GME_Controller
{
	private static final String WSB_URL = 'https://www.reddit.com/r/wallstreetbets/hot.json?limit=20';
	private static final String ALPHA_URL = 'https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=GME&apikey=WG4ZVXDPRR1TBO5A';
	private static final String GET = 'GET';

	@AuraEnabled
	public static String getGMEPrice(){
		String gmePrice = '';
		Map<String, Object> gmeQuote = new Map<String, Object>();
		Http httpCall = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint(ALPHA_URL);
		req.setMethod(GET);

		HttpResponse aplhaResponse = httpCall.send(req);
		gmeQuote = (Map<String, Object>)JSON.deserializeUntyped(aplhaResponse.getBody());
		Map<String, Object> gmeData = (Map<String, Object>) gmeQuote.get('Global Quote');
		System.debug('The price ::: ' + gmeData.get('05. price'));
		gmePrice = (String)gmeData.get('05. price');
		return gmePrice;
	}

	@AuraEnabled
	public static List<RedditTopPosts.PostData> getWSBPosts(){
		List<RedditTopPosts.PostData> postData = new List<RedditTopPosts.PostData>();
		RedditTopPosts wsbTopPosts = new RedditTopPosts();

		Http httpCall = new Http();
		HttpRequest req = new HttpRequest();
		req.setEndpoint(WSB_URL);
		req.setMethod(GET);

		HttpResponse redditResponse = httpCall.send(req);
		wsbTopPosts = RedditTopPosts.parse(redditResponse.getBody());
		List<RedditTopPosts.Children> childPosts = wsbTopPosts.data.children;

		for(RedditTopPosts.Children post : childPosts){
			System.debug('This is the post ::: ' + post);
			System.debug('This is the post data ::: ' + post.data);
			postData.add(post.data);
		}

		return postData;
	}
}