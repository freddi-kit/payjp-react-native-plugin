// LICENSE : MIT
import * as PayjpCardForm from "../src/CardForm";
import { NativeModules } from "react-native";

jest.mock("react-native", () => {
    const emitter = {
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        listeners: {} as any,
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        removers: {} as any,
        addListener: jest.fn((eventName, callback) => {
            emitter.listeners[eventName] = callback;
            const remover = {
                remove: jest.fn()
            };
            emitter.removers[eventName] = remover;
            return remover;
        })
    };
    const mockReactNative = {
        NativeEventEmitter: jest.fn(() => emitter),
        NativeModules: {
            MockEventEmitter: emitter,
            RNPAYCardForm: {
                startCardForm: jest.fn(),
                completeCardForm: jest.fn(),
                showTokenProcessingError: jest.fn()
            }
        }
    };
    return mockReactNative;
});

describe("PayjpCardForm", () => {
    beforeEach(() => {
        jest.clearAllMocks();
    });

    it("startCardForm", async done => {
        expect.assertions(1);
        try {
            await PayjpCardForm.startCardForm();
            expect(NativeModules.RNPAYCardForm.startCardForm).toHaveBeenCalledTimes(1);
            done();
        } catch (e) {
            console.error(e);
        }
    });

    it("startCardForm with tenantId", async done => {
        expect.assertions(2);
        const tenantId = "ten_123";
        try {
            await PayjpCardForm.startCardForm(tenantId);
            expect(NativeModules.RNPAYCardForm.startCardForm).toHaveBeenCalledTimes(1);
            expect(NativeModules.RNPAYCardForm.startCardForm).toHaveBeenCalledWith(tenantId);
            done();
        } catch (e) {
            console.error(e);
        }
    });

    it("completeCardForm", async done => {
        expect.assertions(1);
        try {
            await PayjpCardForm.completeCardForm();
            expect(NativeModules.RNPAYCardForm.completeCardForm).toHaveBeenCalledTimes(1);
            done();
        } catch (e) {
            console.error(e);
        }
    });

    it("showTokenProcessingError", async done => {
        expect.assertions(2);
        const message = "test";
        try {
            await PayjpCardForm.showTokenProcessingError(message);
            expect(NativeModules.RNPAYCardForm.showTokenProcessingError).toHaveBeenCalledTimes(1);
            expect(NativeModules.RNPAYCardForm.showTokenProcessingError).toHaveBeenCalledWith(message);
            done();
        } catch (e) {
            console.error(e);
        }
    });

    it("listen onCardFormCanceled", async done => {
        expect.assertions(1);
        try {
            const onCardFormCanceled = jest.fn();
            PayjpCardForm.onCardFormUpdate({
                onCardFormCanceled,
                onCardFormCompleted: jest.fn(),
                onCardFormProducedToken: jest.fn()
            });
            NativeModules.MockEventEmitter.listeners.onCardFormCanceled();
            expect(onCardFormCanceled).toHaveBeenCalledTimes(1);
            done();
        } catch (e) {
            console.error(e);
        }
    });

    it("listen onCardFormCompleted", async done => {
        expect.assertions(1);
        try {
            const onCardFormCompleted = jest.fn();
            PayjpCardForm.onCardFormUpdate({
                onCardFormCanceled: jest.fn(),
                onCardFormCompleted,
                onCardFormProducedToken: jest.fn()
            });
            NativeModules.MockEventEmitter.listeners.onCardFormCompleted();
            expect(onCardFormCompleted).toHaveBeenCalledTimes(1);
            done();
        } catch (e) {
            console.error(e);
        }
    });

    it("listen onCardFormCompleted", async done => {
        expect.assertions(2);
        try {
            const token = { id: "tok_123" };
            const onCardFormProducedToken = jest.fn();
            PayjpCardForm.onCardFormUpdate({
                onCardFormCanceled: jest.fn(),
                onCardFormCompleted: jest.fn(),
                onCardFormProducedToken
            });
            NativeModules.MockEventEmitter.listeners.onCardFormProducedToken(token);
            expect(onCardFormProducedToken).toHaveBeenCalledTimes(1);
            expect(onCardFormProducedToken).toHaveBeenCalledWith(token);
            done();
        } catch (e) {
            console.error(e);
        }
    });

    it("unsubscribe listener", async done => {
        expect.assertions(3);
        try {
            const unsubscribe = PayjpCardForm.onCardFormUpdate({
                onCardFormCanceled: jest.fn(),
                onCardFormCompleted: jest.fn(),
                onCardFormProducedToken: jest.fn()
            });
            unsubscribe();
            const removers = NativeModules.MockEventEmitter.removers;
            expect(removers.onCardFormCanceled.remove).toHaveBeenCalledTimes(1);
            expect(removers.onCardFormCompleted.remove).toHaveBeenCalledTimes(1);
            expect(removers.onCardFormProducedToken.remove).toHaveBeenCalledTimes(1);
            done();
        } catch (e) {
            console.error(e);
        }
    });
});
