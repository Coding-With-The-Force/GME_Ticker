/**
 * Created by gerry on 1/31/2021.
 */

import {LightningElement} from 'lwc';
import gmePriceRetriever from '@salesforce/apex/GME_Controller.getGMEPrice';
import wsbPostRetriever from '@salesforce/apex/GME_Controller.getWSBPosts';

export default class GmeTicker extends LightningElement {
	gmePrice;
	wsbPosts;
	openModal = false;
	columns = [
		{ label: 'Title', fieldName: 'title' },
		{ label: 'URL', fieldName: 'url_overridden_by_dest', type: 'url' },
		{ label: 'Author', fieldName: 'author_fullname' }
	];

	connectedCallback() {
		this.retrieveGMEPrice();
		this.retrieveWSBPosts();
	}

	retrieveGMEPrice(){
		gmePriceRetriever().then(currentGMEPrice => {
			this.gmePrice = currentGMEPrice;
		}).catch(error =>{
			throw new Error('Something went wrong retrieving the GME price : ' + error);
		});
	}

	retrieveWSBPosts(){
		wsbPostRetriever().then(retrievedPosts =>{
			this.wsbPosts = retrievedPosts;
			console.log('These are the posts ::: ' + JSON.stringify(retrievedPosts));
		}).catch(error =>{
			throw new Error('Something went wrong retrieving wsb posts : ' + error);
		});
	}

	getRandomQuote(){
		return 'HOLD THE LINE!!!';
	}

	setCloseModal(){
		this.openModal = false;
	}

	setOpenModal(){
		this.openModal = true;
	}
}