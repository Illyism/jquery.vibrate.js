describe("Initializing", function() {

	beforeEach(function() {
		var button = $("<div class='button'/>").appendTo("body");
	});

	afterEach(function() {
		$(".button").remove();
	});

	it("Fails without navigator.vibrate", function() {
		$(".button").vibrate({debug: true});

		if ("vibrate" in navigator || "mozVibrate" in navigator	)
			expect($(".button").attr("class")).toBe("button vibrate");
		else
			expect($(".button").attr("class")).not.toBe("button vibrate");

	});

	it("Works with navigator.mozVibrate", function() {
		navigator.mozVibrate = function(pattern) {
			console.log("Vibrating", pattern);
		};
		$(".button").vibrate();
		expect($(".button").attr("class")).toBe("button vibrate");
		navigator.mozVibrate = null;
	});

	it("Works with navigator.vibrate", function() {
		navigator.vibrate = function(pattern) {
			console.log("Vibrating", pattern);
		};
		$(".button").vibrate();
		expect($(".button").attr("class")).toBe("button vibrate");
		navigator.vibrate = null;
	});

	it("Can set a custom class", function() {
		$(".button").vibrate({
			vibrateClass: "bzzz"
		});
		expect($(".button").attr("class")).toBe("button bzzz");
	});

	it("Allows chaining", function() {
		navigator.vibrate = function(pattern) {
			console.log("Vibrating", pattern);
		};
		$(".button")
			.vibrate()
			.text("hello");
		expect($(".button").text()).toBe("hello");
		navigator.vibrate = navigator.mozVibrate = null;
		delete navigator.vibrate; delete navigator.mozVibrate;
		$(".button")
			.vibrate()
			.text("world");
		expect($(".button").text()).toBe("world");
	});


});

describe("Vibrating", function() {

	beforeEach(function() {
		var button = $("<div class='button'/>").appendTo("body");
	});

	afterEach(function() {
		$(".button").remove();
		navigator.vibrate = null;
	});

	it("Vibrates for a short time", function() {
		navigator.vibrate = function(pattern) {
			vibrated = pattern;
		};

		$(".button").vibrate("short");
		var vibrated = false;

		$(".button").click();
		expect(vibrated).toBe(20);
	});

	it("Vibrates for a long time", function() {
		navigator.vibrate = function(pattern) {
			vibrated = pattern;
		};

		$(".button").vibrate("long");
		var vibrated = false;

		$(".button").click();
		expect(vibrated).toBe(100);
	});

	it("Vibrates on mousedown / mouseup", function() {
		navigator.vibrate = function(pattern) {
			vibrated = pattern;
		};

		$(".button").vibrate({
			trigger: "mousedown",
			debug: true
		});

		var vibrated = false;

		$(".button").mousedown();
		$(".button").mouseup();
		expect(vibrated).toBe(0);
	});

});