/* tslint:disable */
/* eslint-disable */
/**
 * PAY.JP Token API
 * No description provided (generated by Openapi Generator https://github.com/openapitools/openapi-generator)
 *
 * The version of the OpenAPI document: 0.1.0
 *
 *
 * NOTE: This class is auto generated by OpenAPI Generator (https://openapi-generator.tech).
 * https://openapi-generator.tech
 * Do not edit the class manually.
 */

/**
 *
 * @export
 * @enum {string}
 */
export enum CardBrand {
    Visa = "Visa",
    MasterCard = "MasterCard",
    JCB = "JCB",
    AmericanExpress = "American Express",
    DinersClub = "Diners Club",
    Discover = "Discover",
}

export function CardBrandFromJSON(json: any): CardBrand {
    return CardBrandFromJSONTyped(json, false);
}

export function CardBrandFromJSONTyped(json: any, ignoreDiscriminator: boolean): CardBrand {
    return json as CardBrand;
}

export function CardBrandToJSON(value?: CardBrand | null): any {
    return value as any;
}
