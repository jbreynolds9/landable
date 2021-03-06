require 'spec_helper'

describe Landable::Asset do
  def asset_fixture(name)
    File.expand_path("../../../fixtures/assets/#{name}", __FILE__)
  end

  let(:png) { File.open(asset_fixture('panda.png')) }
  let(:pdf) { File.open(asset_fixture('small.pdf')) }

  after do
    png.close
    pdf.close
  end

  it { is_expected.not_to have_valid(:name).when(nil, '', 'No Spaces') }
  it { is_expected.not_to have_valid(:author).when(nil) }
  it { is_expected.not_to have_valid(:md5sum).when(nil, '') }
  it { is_expected.not_to have_valid(:mime_type).when(nil, '') }
  it { is_expected.not_to have_valid(:file_size).when(nil, 1.5) }

  it 'stores an md5sum of its contents' do
    asset = build(:asset, data: png)
    expect { asset.valid? }.to change { asset.md5sum }.from(nil).to('0f62ef551dbebcdb7379401528b6115c')
  end

  it 'requires the md5sum to be unique' do
    create(:asset, data: png)
    dupe = build(:asset, data: png)

    expect(dupe).not_to be_valid
    expect(dupe.errors[:md5sum]).to eq(['has already been taken'])
  end

  it 'provides access to the other asset with the same contents' do
    orig = create(:asset, data: png)
    dupe = build(:asset, data: png)
    expect(dupe.duplicate_of).to eql(orig)
  end

  it 'returns a list of pages using the asset' do
    create(:page, body: 'panda.png', path: '/testing/assets')
    asset = create(:asset, data: pdf, name: 'panda.png')
    expect(asset.associated_pages).to eq(['/testing/assets'])
  end
end
