RSpec.describe Guard::CoffeeScript do
  let(:guard) { Guard::CoffeeScript.new }

  let(:runner) { Guard::CoffeeScript::Runner }
  let(:inspector) { Guard::CoffeeScript::Inspector }

  let(:defaults) { Guard::CoffeeScript::DEFAULT_OPTIONS }

  before do
    allow(inspector).to receive(:clean)
    allow(runner).to receive(:run)
    allow(runner).to receive(:remove)
  end

  describe '#initialize' do
    context 'when no options are provided' do
      it 'sets a default :watchers option' do
        expect(guard.watchers).to be_a Array
        expect(guard.watchers).to be_empty
      end

      it 'sets a default :wrap option' do
        expect(guard.options[:bare]).to be_falsey
      end

      it 'sets a default :shallow option' do
        expect(guard.options[:shallow]).to be_falsey
      end

      it 'sets a default :hide_success option' do
        expect(guard.options[:hide_success]).to be_falsey
      end

      it 'sets a default :noop option' do
        expect(guard.options[:noop]).to be_falsey
      end

      it 'sets a default :all_on_start option' do
        expect(guard.options[:all_on_start]).to be_falsey
      end

      it 'sets the provided :source_maps option' do
        expect(guard.options[:source_map]).to be_falsey
      end
    end

    context 'with options besides the defaults' do
      let(:watcher) { Guard::Watcher.new('^x/.+\.(?:coffee|coffee\.md|litcoffee)$') }

      let(:guard) do
        Guard::CoffeeScript.new(output: 'output_folder',
                                bare: true,
                                shallow: true,
                                hide_success: true,
                                all_on_start: true,
                                noop: true,
                                source_map: true,
                                watchers: [watcher]
      )
      end

      it 'sets the provided :watchers option' do
        expect(guard.watchers).to eq([watcher])
      end

      it 'sets the provided :bare option' do
        expect(guard.options[:bare]).to be_truthy
      end

      it 'sets the provided :shallow option' do
        expect(guard.options[:shallow]).to be_truthy
      end

      it 'sets the provided :hide_success option' do
        expect(guard.options[:hide_success]).to be_truthy
      end

      it 'sets the provided :noop option' do
        expect(guard.options[:noop]).to be_truthy
      end

      it 'sets the provided :all_on_start option' do
        expect(guard.options[:all_on_start]).to be_truthy
      end

      it 'sets the provided :source_maps option' do
        expect(guard.options[:source_map]).to be_truthy
      end
    end

    context 'with a input option' do
      let(:guard) { Guard::CoffeeScript.new(input: 'app/coffeescripts') }

      it 'creates a watcher' do
        expect(guard.watchers.size).to eq(1)
      end

      it 'watches all *.{coffee,coffee.md,litcoffee} files' do
        expect(guard.watchers.first.pattern).to eql %r{^app/coffeescripts/(.+\.(?:coffee|coffee\.md|litcoffee))$}
      end

      context 'without an output option' do
        it 'sets the output directory to the input directory' do
          expect(guard.options[:output]).to eql 'app/coffeescripts'
        end
      end

      context 'with an output option' do
        let(:guard) do
          Guard::CoffeeScript.new(input: 'app/coffeescripts',
                                  output: 'public/javascripts')
        end

        it 'keeps the output directory' do
          expect(guard.options[:output]).to eql 'public/javascripts'
        end
      end
    end
  end

  describe '#start' do
    it 'calls #run_all' do
      expect(guard).not_to receive(:run_all)
      guard.start
    end

    context 'with the :all_on_start option' do
      let(:guard) { Guard::CoffeeScript.new(all_on_start: true) }

      it 'calls #run_all' do
        expect(guard).to receive(:run_all)
        guard.start
      end
    end
  end

  describe '#run_all' do
    let(:guard) { Guard::CoffeeScript.new(watchers: [Guard::Watcher.new('^x/.+\.(?:coffee|coffee\.md|litcoffee)$')]) }

    before do
      allow(Dir).to receive(:glob).and_return ['x/a.coffee', 'x/b.coffee', 'y/c.coffee', 'x/d.coffeeemd', 'x/e.litcoffee']
    end

    it 'runs the run_on_modifications with all watched CoffeeScripts' do
      expect(guard).to receive(:run_on_modifications).with(['x/a.coffee', 'x/b.coffee', 'x/e.litcoffee'])
      guard.run_all
    end
  end

  describe '#run_on_modifications' do
    it 'throws :task_has_failed when an error occurs' do
      expect(inspector).to receive(:clean).with(['a.coffee', 'b.coffee']).and_return ['a.coffee']
      expect(runner).to receive(:run).with(['a.coffee'], [], defaults).and_return [[], false]
      expect { guard.run_on_modifications(['a.coffee', 'b.coffee']) }.to throw_symbol :task_has_failed
    end

    it 'starts the Runner with the cleaned files' do
      expect(inspector).to receive(:clean).with(['a.coffee', 'b.coffee']).and_return ['a.coffee']
      expect(runner).to receive(:run).with(['a.coffee'], [], defaults).and_return [['a.js'], true]
      guard.run_on_modifications(['a.coffee', 'b.coffee'])
    end
  end

  describe '#run_on_removals' do
    it 'cleans the paths accepting missing files' do
      expect(inspector).to receive(:clean).with(['a.coffee', 'b.coffee'],  missing_ok: true)
      guard.run_on_removals(['a.coffee', 'b.coffee'])
    end

    it 'removes the files' do
      expect(inspector).to receive(:clean).and_return ['a.coffee', 'b.coffee']
      expect(runner).to receive(:remove).with(['a.coffee', 'b.coffee'], guard.watchers, guard.options)
      guard.run_on_removals(['a.coffee', 'b.coffee'])
    end
  end
end
